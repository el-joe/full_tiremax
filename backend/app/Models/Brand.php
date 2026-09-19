<?php

namespace App\Models;

use Astrotomic\Translatable\Contracts\Translatable as TranslatableContract;
use Astrotomic\Translatable\Translatable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Brand extends Model implements TranslatableContract
{
    use \App\Models\Concerns\SearchesTranslations;
    use Translatable, SoftDeletes;

    protected $fillable = ['daftra_id', 'slug', 'logo', 'country', 'is_active', 'sort_order'];

    protected $casts = ['is_active' => 'boolean'];

    public array $translatedAttributes = ['name', 'description'];

    public function products(): HasMany
    {
        return $this->hasMany(Product::class);
    }

    function scopeActive($query)
    {
        return $query->where('is_active', true);
    }
}
