<?php

namespace App\Models;

use Astrotomic\Translatable\Contracts\Translatable as TranslatableContract;
use Astrotomic\Translatable\Translatable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Service extends Model implements TranslatableContract
{
    use Translatable;

    protected $fillable = ['slug', 'icon', 'image', 'duration_minutes', 'price', 'is_active', 'sort_order'];
    protected $casts = ['is_active' => 'boolean', 'price' => 'decimal:2'];

    public array $translatedAttributes = ['name', 'description'];

    public function branches(): BelongsToMany
    {
        return $this->belongsToMany(Branch::class, 'branch_service')
            ->withPivot(['price_override', 'is_active']);
    }
}
