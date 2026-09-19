<?php

namespace App\Models;

use Astrotomic\Translatable\Contracts\Translatable as TranslatableContract;
use Astrotomic\Translatable\Translatable;
use Illuminate\Database\Eloquent\Model;

class Category extends Model implements TranslatableContract
{
    use \App\Models\Concerns\SearchesTranslations;
    use Translatable;

    protected $fillable = ['daftra_id', 'slug', 'product_type', 'icon', 'is_active', 'sort_order'];
    protected $casts = ['is_active' => 'boolean'];

    public array $translatedAttributes = ['name', 'description'];
}
