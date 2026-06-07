<?php

namespace App\Models;

use Astrotomic\Translatable\Contracts\Translatable as TranslatableContract;
use Astrotomic\Translatable\Translatable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Database\Eloquent\SoftDeletes;

class Product extends Model implements TranslatableContract
{
    use Translatable, SoftDeletes;

    public const TYPE_TIRE = 'tire';
    public const TYPE_BATTERY = 'battery';

    public const BADGE_BEST_SELLER = 'best_seller';
    public const BADGE_BEST_CHOICE = 'best_choice';
    public const BADGE_SPECIAL_OFFER = 'special_offer';
    public const BADGE_NEW = 'new';

    protected $fillable = [
        'daftra_id',
        'type',
        'sku',
        'brand_id',
        'category_id',
        'price',
        'sale_price',
        'cost',
        'stock',
        'low_stock_threshold',
        'manufacture_year',
        'manufacturer_warranty_months',
        'agency_warranty_months',
        'expert_rating',
        'virtual_sales_count',
        'virtual_views_count',
        'real_sales_count',
        'real_views_count',
        'sort_order',
        'is_active',
        'is_featured',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'sale_price' => 'decimal:2',
        'cost' => 'decimal:2',
        'expert_rating' => 'decimal:1',
        'is_active' => 'boolean',
        'is_featured' => 'boolean',
    ];

    public array $translatedAttributes = [
        'name',
        'short_description',
        'description',
        'pattern_name',
        'usage_notes',
        'meta_title',
        'meta_description',
    ];

    public function brand(): BelongsTo
    {
        return $this->belongsTo(Brand::class);
    }

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    public function images(): HasMany
    {
        return $this->hasMany(ProductImage::class)->orderBy('sort_order');
    }

    public function badges(): HasMany
    {
        return $this->hasMany(ProductBadge::class);
    }

    public function tireSpec(): HasOne
    {
        return $this->hasOne(TireSpec::class);
    }

    public function batterySpec(): HasOne
    {
        return $this->hasOne(BatterySpec::class);
    }

    public function fitments(): HasMany
    {
        return $this->hasMany(Fitment::class);
    }

    public function reviews(): HasMany
    {
        return $this->hasMany(Review::class);
    }

    public function flashSales(): \Illuminate\Database\Eloquent\Relations\BelongsToMany
    {
        return $this->belongsToMany(FlashSale::class, 'flash_sale_products');
    }

    public function activeFlashSale(): \Illuminate\Database\Eloquent\Relations\BelongsToMany
    {
        $now = now();
        return $this->belongsToMany(FlashSale::class, 'flash_sale_products')
            ->where('is_active', true)
            ->where('starts_at', '<=', $now)
            ->where('ends_at', '>=', $now);
    }

    public function scopeActive(Builder $q): Builder
    {
        return $q->where('is_active', true);
    }

    public function scopeOfType(Builder $q, string $type): Builder
    {
        return $q->where('type', $type);
    }

    public function getEffectivePriceAttribute(): float
    {
        return (float) ($this->sale_price ?? $this->price);
    }

    public function getDisplaySalesCountAttribute(): int
    {
        return $this->real_sales_count + $this->virtual_sales_count;
    }

    public function getDisplayViewsCountAttribute(): int
    {
        return $this->real_views_count + $this->virtual_views_count;
    }
}
