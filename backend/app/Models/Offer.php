<?php

namespace App\Models;

use Astrotomic\Translatable\Contracts\Translatable as TranslatableContract;
use Astrotomic\Translatable\Translatable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Offer extends Model implements TranslatableContract
{
    use \App\Models\Concerns\SearchesTranslations;
    use Translatable;

    protected $fillable = [
        'code',
        'discount_type',
        'discount_value',
        'min_subtotal',
        'usage_limit',
        'used_count',
        'starts_at',
        'ends_at',
        'is_active',
    ];

    protected $casts = [
        'starts_at' => 'datetime',
        'ends_at' => 'datetime',
        'is_active' => 'boolean',
        'discount_value' => 'decimal:2',
        'min_subtotal' => 'decimal:2',
    ];

    public array $translatedAttributes = ['title', 'description'];

    public function products(): BelongsToMany
    {
        return $this->belongsToMany(Product::class, 'offer_product');
    }

    public function governorates(): BelongsToMany
    {
        return $this->belongsToMany(Governorate::class, 'offer_governorate');
    }

    public function customers(): BelongsToMany
    {
        return $this->belongsToMany(Customer::class, 'offer_customer');
    }

    public function isLive(): bool
    {
        $now = now();
        return $this->is_active
            && (!$this->starts_at || $this->starts_at->lte($now))
            && (!$this->ends_at || $this->ends_at->gte($now))
            && (!$this->usage_limit || $this->used_count < $this->usage_limit);
    }
}
