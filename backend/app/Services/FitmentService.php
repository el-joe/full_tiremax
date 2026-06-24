<?php

namespace App\Services;

use App\Models\Fitment;
use App\Models\Product;
use App\Models\TireSpec;
use App\Models\Vehicle;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Support\Facades\DB;

class FitmentService
{
    public function productsForVehicle(Vehicle $vehicle, array $filters = []): Collection
    {
        $excluded = $vehicle->fitments()->where('is_excluded', true)->pluck('product_id');

        $q = Product::active()
            ->whereHas('fitments', fn($qb) => $qb->where('vehicle_id', $vehicle->id)->where('is_excluded', false))
            ->whereNotIn('id', $excluded)
            ->with(['brand', 'images', 'badges', 'tireSpec', 'batterySpec']);

        if (!empty($filters['type'])) {
            $q->ofType($filters['type']);
        }

        return $q->orderBy('sort_order')->get();
    }

    public function availableSizes(): \Illuminate\Support\Collection
    {
        return TireSpec::select('width', 'aspect_ratio', 'rim_diameter')
            ->distinct()
            ->orderBy('width')
            ->orderBy('aspect_ratio')
            ->orderBy('rim_diameter')
            ->get();
    }

    public function productsBySize(array $size): Collection
    {
        return Product::active()
            ->ofType(Product::TYPE_TIRE)
            ->whereHas('tireSpec', function ($q) use ($size) {
                $q->where('width', $size['width'])
                    ->where('aspect_ratio', $size['aspect_ratio'])
                    ->where('rim_diameter', $size['rim_diameter']);
            })
            ->with(['brand', 'images', 'badges', 'tireSpec'])
            ->get();
    }

    public function attach(array $data): Fitment
    {
        return DB::transaction(function () use ($data) {
            $fitment = Fitment::create([
                'vehicle_id' => $data['vehicle_id'],
                'product_id' => $data['product_id'],
                'year_from' => $data['year_from'] ?? null,
                'year_to' => $data['year_to'] ?? null,
                'trim' => $data['trim'] ?? null,
                'is_alternative' => $data['is_alternative'] ?? false,
                'is_excluded' => $data['is_excluded'] ?? false,
                'is_oem' => $data['is_oem'] ?? false,
            ]);

            foreach ($data['notes'] ?? [] as $locale => $note) {
                $fitment->translateOrNew($locale)->notes = $note;
            }
            $fitment->save();

            return $fitment;
        });
    }

    public function update(Fitment $fitment, array $data): Fitment
    {
        return DB::transaction(function () use ($fitment, $data) {
            $fitment->update(array_filter([
                'year_from' => $data['year_from'] ?? null,
                'year_to' => $data['year_to'] ?? null,
                'trim' => $data['trim'] ?? null,
                'is_alternative' => $data['is_alternative'] ?? null,
                'is_excluded' => $data['is_excluded'] ?? null,
                'is_oem' => $data['is_oem'] ?? null,
            ], fn($v) => $v !== null));

            foreach ($data['notes'] ?? [] as $locale => $note) {
                $fitment->translateOrNew($locale)->notes = $note;
            }
            $fitment->save();

            return $fitment->fresh();
        });
    }

    public function delete(Fitment $fitment): void
    {
        $fitment->delete();
    }
}
