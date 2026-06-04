<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class FlashSale extends Model
{
    protected $fillable = ['title', 'discount_percent', 'starts_at', 'ends_at', 'is_active'];

    protected $casts = [
        'starts_at' => 'datetime',
        'ends_at' => 'datetime',
        'is_active' => 'boolean',
        'discount_percent' => 'decimal:2',
    ];

    public function products(): BelongsToMany
    {
        return $this->belongsToMany(Product::class, 'flash_sale_products');
    }

    public function scopeActive(Builder $q): Builder
    {
        $now = now();
        return $q->where('is_active', true)
            ->where('starts_at', '<=', $now)
            ->where('ends_at', '>=', $now);
    }

    public function getIsRunningAttribute(): bool
    {
        $now = now();
        return $this->is_active
            && $this->starts_at <= $now
            && $this->ends_at >= $now;
    }

    public function getCountdownSecondsAttribute(): int
    {
        if (!$this->is_running) {
            return 0;
        }
        return (int) max(0, now()->diffInSeconds($this->ends_at));
    }

    public function getStatusAttribute(): string
    {
        $now = now();
        if (!$this->is_active) {
            return 'inactive';
        }
        if ($this->starts_at > $now) {
            return 'upcoming';
        }
        if ($this->ends_at < $now) {
            return 'expired';
        }
        return 'active';
    }
}
