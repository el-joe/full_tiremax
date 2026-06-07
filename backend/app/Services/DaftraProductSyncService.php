<?php

namespace App\Services;

use App\Integrations\Daftra;
use App\Models\Brand;
use App\Models\BrandTranslation;
use App\Models\Category;
use App\Models\CategoryTranslation;
use App\Models\DaftraSyncLog;
use App\Models\Product;
use App\Models\ProductTranslation;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;
use Throwable;

/**
 * Syncs products, brands and categories from Daftra into the local database.
 *
 * Response shape expected from Daftra::listProducts():
 *   ['data']['data']       → array of {'Product': {...}}
 *   ['data']['pagination'] → {page, page_count, total_results, ...}
 *
 * For each Product:
 *   - brand   is identified by brand_id (daftra_id on brands table)
 *   - category is identified by ProductCategory[0].id (daftra_id on categories table)
 *   - stock   is the SUM of ProductStock[*].balance
 */
class DaftraProductSyncService
{
    public function __construct(private readonly Daftra $daftra)
    {
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Public API
    // ──────────────────────────────────────────────────────────────────────────

    /**
     * Sync one page.  Returns ['synced', 'errors', 'pagination'].
     */
    public function syncPage(int $page = 1, int $limit = 50): array
    {
        $response = $this->daftra->listProducts($page, $limit);
        $products = $response['data'] ?? [];
        $pagination = $response['pagination'] ?? [];

        $synced = $errors = 0;

        foreach ($products as $item) {
            $productData = $item['Product'] ?? $item;

            try {
                DB::transaction(fn() => $this->syncProduct($productData));
                $synced++;
            } catch (Throwable $e) {
                $errors++;
                Log::error('DaftraProductSync: failed', [
                    'daftra_id' => $productData['id'] ?? null,
                    'name' => $productData['name'] ?? null,
                    'error' => $e->getMessage(),
                ]);

                DaftraSyncLog::create([
                    'syncable_type' => Product::class,
                    'syncable_id' => null,
                    'action' => 'sync_product',
                    'status' => 'failed',
                    'payload' => ['daftra_id' => $productData['id'] ?? null, 'name' => $productData['name'] ?? null],
                    'response' => ['error' => $e->getMessage()],
                    'attempts' => 1,
                ]);
            }
        }

        return compact('synced', 'errors', 'pagination');
    }

    /**
     * Sync every page until done.
     * $onPage(int $page, array $result) is called after each page (optional).
     */
    public function syncAll(int $limit = 50, ?callable $onPage = null): array
    {
        $page = 1;
        $totalSynced = 0;
        $totalErrors = 0;

        do {
            $result = $this->syncPage($page, $limit);
            $totalSynced += $result['synced'];
            $totalErrors += $result['errors'];

            if ($onPage) {
                $onPage($page, $result);
            }

            $pageCount = (int) ($result['pagination']['page_count'] ?? 1);
            $page++;
        } while ($page <= $pageCount);

        return ['synced' => $totalSynced, 'errors' => $totalErrors];
    }

    /**
     * Upsert one product (and its brand/category) from raw Daftra data.
     */
    public function syncProduct(array $data): Product
    {
        $daftraId = (string) $data['id'];

        // ── Brand ──────────────────────────────────────────────────────────
        $brand = null;
        if (!empty($data['brand_id'])) {
            $brand = $this->upsertBrand((string) $data['brand_id'], (string) ($data['brand'] ?? ''));
        } else {
            // If no brand_id provided, assign to default brand to avoid nulls.
            $brand = $this->getDefaultBrand();
        }

        // ── Category ───────────────────────────────────────────────────────
        $category = null;
        $catSource = $data['ProductCategory'][0] ?? null;
        if ($catSource) {
            $category = $this->upsertCategory((string) $catSource['id'], (string) ($catSource['name'] ?? ''));
        } else {
            $category = $this->defaultCategory();
        }

        // ── Stock (sum of all warehouse balances) ──────────────────────────
        $stock = (int) array_sum(array_column($data['ProductStock'] ?? [], 'balance'));

        // ── SKU ────────────────────────────────────────────────────────────
        $rawSku = trim((string) ($data['product_code'] ?? ''));
        $sku = $rawSku !== '' ? $rawSku : ('DAFTRA-' . $daftraId);

        // Ensure the SKU is not taken by a non-daftra record
        $sku = $this->resolveUniqueSku($sku, $daftraId);

        // ── Pricing ────────────────────────────────────────────────────────
        $unitPrice = $data['unit_price'] !== null ? (float) $data['unit_price'] : 0.0;
        $buyPrice = $data['buy_price'] !== null ? (float) $data['buy_price'] : null;

        $lowStockThreshold = (int) ($data['low_stock_thershold'] ?? 5);
        $isActive = (($data['deactivate'] ?? '0') === '0');

        // ── Upsert product ─────────────────────────────────────────────────
        /** @var Product $product */
        $product = Product::withTrashed()->where('daftra_id', $daftraId)->first();

        $stock = ($stock < 0) ? 99999 : $stock; // ensure non-negative stock

        if ($product) {
            if ($product->trashed()) {
                $product->restore();
            }
            $product->update([
                'sku' => $sku,
                'brand_id' => $brand?->id,
                'category_id' => $category?->id,
                'price' => $unitPrice > 0 ? $unitPrice : $product->price,
                'cost' => $buyPrice,
                'stock' => $stock,
                'low_stock_threshold' => $lowStockThreshold,
                'is_active' => $isActive,
            ]);
        } else {
            $product = Product::create([
                'daftra_id' => $daftraId,
                'type' => 'tire',
                'sku' => $sku,
                'brand_id' => $brand?->id,
                'category_id' => $category?->id,
                'price' => $unitPrice > 0 ? $unitPrice : 0.01,
                'cost' => $buyPrice,
                'stock' => $stock,
                'low_stock_threshold' => $lowStockThreshold,
                'is_active' => $isActive,
            ]);
        }

        // ── Translations (Arabic name from Daftra; use same for EN as fallback) ──
        $name = trim((string) ($data['name'] ?? ''));
        foreach (['ar', 'en'] as $locale) {
            ProductTranslation::updateOrCreate(
                ['product_id' => $product->id, 'locale' => $locale],
                ['name' => $name ?: ('Product #' . $daftraId)]
            );
        }

        return $product->fresh();
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Brand / Category upsert helpers
    // ──────────────────────────────────────────────────────────────────────────

    public function upsertBrand(string $daftraId, string $name): Brand
    {
        $name = trim($name) ?: ('Brand #' . $daftraId);

        /** @var Brand|null $brand */
        $brand = Brand::withTrashed()->where('daftra_id', $daftraId)->first();

        if ($brand) {
            if ($brand->trashed()) {
                $brand->restore();
            }
        } else {
            $slug = $this->uniqueSlug('brand-' . $daftraId, 'brands');
            $brand = Brand::create([
                'daftra_id' => $daftraId,
                'slug' => $slug,
                'is_active' => true,
            ]);
        }


        foreach (['ar', 'en'] as $locale) {
            BrandTranslation::updateOrCreate(
                ['brand_id' => $brand->id, 'locale' => $locale],
                ['name' => $name],
            );
        }

        return $brand;
    }

    // default brand
    public function getDefaultBrand(): Brand
    {
        $defaultDaftraBrandId = '0'; // or any other reserved ID for the default brand

        return $this->upsertBrand($defaultDaftraBrandId, 'Default Brand');
    }

    public function upsertCategory(string $daftraId, string $name): Category
    {
        $name = trim($name) ?: ('Category #' . $daftraId);

        /** @var Category|null $category */
        $category = Category::where('daftra_id', $daftraId)->first();

        if (!$category) {
            $slug = $this->uniqueSlug('cat-' . $daftraId, 'categories');
            $category = Category::create([
                'daftra_id' => $daftraId,
                'slug' => $slug,
                'product_type' => 'tire',
                'is_active' => true,
            ]);
        }

        foreach (['ar', 'en'] as $locale) {
            CategoryTranslation::updateOrCreate(
                ['category_id' => $category->id, 'locale' => $locale],
                ['name' => $name]
            );
        }

        return $category;
    }

    // default category
    public function defaultCategory(): Category
    {
        $defaultDaftraCategoryId = '0'; // or any other reserved ID for the default category
        return $this->upsertCategory($defaultDaftraCategoryId, 'Default Category');
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Slug / SKU uniqueness helpers
    // ──────────────────────────────────────────────────────────────────────────

    private function uniqueSlug(string $base, string $table): string
    {
        $slug = $base;
        $i = 1;

        while (DB::table($table)->where('slug', $slug)->exists()) {
            $slug = $base . '-' . $i++;
        }

        return $slug;
    }

    private function resolveUniqueSku(string $sku, string $daftraId): string
    {
        // If the current daftra product already owns this SKU, keep it.
        $owner = Product::withTrashed()->where('sku', $sku)->first();

        if (!$owner || (string) $owner->daftra_id === $daftraId) {
            return $sku;
        }

        // SKU taken by another record – suffix with daftra_id to guarantee uniqueness.
        return $sku . '-D' . $daftraId;
    }
}
