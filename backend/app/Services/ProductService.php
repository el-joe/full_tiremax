<?php

namespace App\Services;

use App\Models\Product;
use App\Models\ProductView;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Facades\DB;

class ProductService
{
    public function paginate(array $filters): LengthAwarePaginator
    {
        return $this->buildQuery($filters)
            ->paginate((int) ($filters['per_page'] ?? 15));
    }

    public function buildQuery(array $filters): Builder
    {
        $q = Product::query()
            ->active()
            ->with(['brand', 'category', 'images', 'badges', 'tireSpec', 'batterySpec', 'activeFlashSale'])
            ->withCount(['reviews as reviews_count' => fn($q) => $q->where('is_approved', true)]);

        if (!empty($filters['type'])) {
            $q->ofType($filters['type']);
        }

        if (!empty($filters['brand_id'])) {
            $q->whereIn('brand_id', (array) $filters['brand_id']);
        }

        if (!empty($filters['category_id'])) {
            $q->where('category_id', $filters['category_id']);
        }

        if (!empty($filters['badge'])) {
            $q->whereHas('badges', fn($qb) => $qb->where('badge', $filters['badge']));
        }

        if (!empty($filters['min_price'])) {
            $q->where('price', '>=', $filters['min_price']);
        }

        if (!empty($filters['max_price'])) {
            $q->where('price', '<=', $filters['max_price']);
        }

        if (!empty($filters['search'])) {
            $term = $filters['search'];
            $q->whereHas('translations', fn($qb) => $qb->where('name', 'like', "%{$term}%"));
        }

        // Tire size filter
        foreach (['width', 'aspect_ratio', 'rim_diameter'] as $key) {
            if (!empty($filters[$key])) {
                $q->whereHas('tireSpec', fn($qb) => $qb->where($key, $filters[$key]));
            }
        }

        if (!empty($filters['vehicle_id'])) {
            $vehicleId = (int) $filters['vehicle_id'];
            $q->whereHas('fitments', fn($qb) => $qb
                ->where('vehicle_id', $vehicleId)
                ->where('is_excluded', false));
        }

        $sort = $filters['sort'] ?? 'sort_order';
        $dir = $filters['direction'] ?? 'asc';
        $allowed = ['sort_order', 'price', 'created_at', 'expert_rating', 'real_sales_count'];
        if (!in_array($sort, $allowed, true)) {
            $sort = 'sort_order';
        }
        $q->orderBy($sort, $dir === 'desc' ? 'desc' : 'asc');

        return $q;
    }

    public function trackView(Product $product, ?int $customerId, ?string $ip, ?string $ua): void
    {
        ProductView::create([
            'product_id' => $product->id,
            'customer_id' => $customerId,
            'ip' => $ip,
            'user_agent' => $ua,
        ]);
        $product->increment('real_views_count');
    }

    public function relatedProducts(Product $product, int $limit = 8): \Illuminate\Database\Eloquent\Collection
    {
        return Product::active()
            ->ofType($product->type)
            ->where('id', '!=', $product->id)
            ->where(function ($q) use ($product) {
                $q->where('brand_id', $product->brand_id)
                    ->orWhere('category_id', $product->category_id);
            })
            ->with(['brand', 'images', 'badges'])
            ->limit($limit)
            ->get();
    }

    public function create(array $data): Product
    {
        return DB::transaction(function () use ($data) {
            $product = Product::create($data['core']);

            $product->translations()->createMany($this->buildTranslations($data['translations'] ?? []));

            if (!empty($data['tire_spec'])) {
                $product->tireSpec()->create($data['tire_spec']);
            }
            if (!empty($data['battery_spec'])) {
                $product->batterySpec()->create($data['battery_spec']);
            }
            if (!empty($data['badges'])) {
                foreach ($data['badges'] as $b) {
                    $product->badges()->create(['badge' => $b]);
                }
            }
            if (!empty($data['images'])) {
                foreach ($data['images'] as $i => $img) {
                    $product->images()->create([
                        'path' => $img['path'],
                        'is_primary' => $i === 0,
                        'sort_order' => $i,
                    ]);
                }
            }
            return $product->load(['brand', 'category', 'translations', 'tireSpec', 'batterySpec', 'badges', 'images']);
        });
    }

    public function update(Product $product, array $data): Product
    {
        return DB::transaction(function () use ($product, $data) {
            $product->update($data['core'] ?? []);

            foreach ($data['translations'] ?? [] as $locale => $tr) {
                $product->translateOrNew($locale)->fill($tr);
            }
            $product->save();

            if (array_key_exists('tire_spec', $data)) {
                if ($data['tire_spec']) {
                    $product->tireSpec()->updateOrCreate(['product_id' => $product->id], $data['tire_spec']);
                } else {
                    $product->tireSpec()?->delete();
                }
            }
            if (array_key_exists('battery_spec', $data)) {
                if ($data['battery_spec']) {
                    $product->batterySpec()->updateOrCreate(['product_id' => $product->id], $data['battery_spec']);
                } else {
                    $product->batterySpec()?->delete();
                }
            }
            if (array_key_exists('badges', $data)) {
                $product->badges()->delete();
                foreach ((array) $data['badges'] as $b) {
                    $product->badges()->create(['badge' => $b]);
                }
            }

            return $product->fresh(['brand', 'category', 'translations', 'tireSpec', 'batterySpec', 'badges', 'images']);
        });
    }

    public function delete(Product $product): void
    {
        $product->delete();
    }

    protected function buildTranslations(array $translations): array
    {
        $rows = [];
        foreach ($translations as $locale => $values) {
            $rows[] = array_merge(['locale' => $locale], $values);
        }
        return $rows;
    }
}
