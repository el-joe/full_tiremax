<?php

namespace App\Services;

use App\Models\Vehicle;
use App\Models\VehicleMake;
use App\Models\VehicleModel;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class VehicleService
{
    public function makes(): Collection
    {
        return VehicleMake::query()
            ->where('is_active', true)
            ->with('translations')
            ->orderBy('sort_order')
            ->get();
    }

    public function models(VehicleMake $make): Collection
    {
        return $make->models()
            ->where('is_active', true)
            ->with('translations')
            ->orderBy('sort_order')
            ->get();
    }

    public function years(VehicleModel $model): Collection
    {
        return $model->vehicles()
            ->where('is_active', true)
            ->with('translations')
            ->orderByDesc('year_from')
            ->get();
    }

    public function createVehicle(array $data): Vehicle
    {
        return DB::transaction(function () use ($data) {
            $vehicle = Vehicle::create([
                'vehicle_model_id' => $data['vehicle_model_id'],
                'year_from' => $data['year_from'],
                'year_to' => $data['year_to'] ?? null,
                'trim_code' => $data['trim_code'] ?? null,
                'engine' => $data['engine'] ?? null,
                'is_active' => $data['is_active'] ?? true,
            ]);

            foreach ($data['translations'] ?? [] as $locale => $tr) {
                $vehicle->translateOrNew($locale)->fill($tr);
            }
            $vehicle->save();

            return $vehicle->fresh();
        });
    }

    public function updateVehicle(Vehicle $vehicle, array $data): Vehicle
    {
        return DB::transaction(function () use ($vehicle, $data) {
            $vehicle->update(array_filter([
                'vehicle_model_id' => $data['vehicle_model_id'] ?? null,
                'year_from' => $data['year_from'] ?? null,
                'year_to' => $data['year_to'] ?? null,
                'trim_code' => $data['trim_code'] ?? null,
                'engine' => $data['engine'] ?? null,
                'is_active' => $data['is_active'] ?? null,
            ], fn($v) => $v !== null));

            foreach ($data['translations'] ?? [] as $locale => $tr) {
                $vehicle->translateOrNew($locale)->fill($tr);
            }
            $vehicle->save();

            return $vehicle->fresh();
        });
    }

    public function createMake(array $data): VehicleMake
    {
        return DB::transaction(function () use ($data) {
            $make = VehicleMake::create([
                'slug' => $data['slug'] ?? Str::slug($data['translations']['en']['name'] ?? 'make-' . uniqid()),
                'logo' => $data['logo'] ?? null,
                'is_active' => $data['is_active'] ?? true,
                'sort_order' => $data['sort_order'] ?? 0,
            ]);
            foreach ($data['translations'] ?? [] as $locale => $tr) {
                $make->translateOrNew($locale)->fill($tr);
            }
            $make->save();
            return $make;
        });
    }

    public function createModel(array $data): VehicleModel
    {
        return DB::transaction(function () use ($data) {
            $model = VehicleModel::create([
                'vehicle_make_id' => $data['vehicle_make_id'],
                'slug' => $data['slug'] ?? Str::slug($data['translations']['en']['name'] ?? 'model-' . uniqid()),
                'is_active' => $data['is_active'] ?? true,
                'sort_order' => $data['sort_order'] ?? 0,
            ]);
            foreach ($data['translations'] ?? [] as $locale => $tr) {
                $model->translateOrNew($locale)->fill($tr);
            }
            $model->save();
            return $model;
        });
    }
}
