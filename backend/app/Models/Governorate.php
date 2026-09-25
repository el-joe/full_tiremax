<?php

namespace App\Models;

use Astrotomic\Translatable\Contracts\Translatable as TranslatableContract;
use Astrotomic\Translatable\Translatable;
use Illuminate\Database\Eloquent\Model;

class Governorate extends Model implements TranslatableContract
{
    use \App\Models\Concerns\SearchesTranslations;
    use Translatable;

    protected $fillable = ['code', 'is_basra', 'shipping_fee', 'is_active', 'sort_order'];

    protected $casts = [
        'is_basra' => 'boolean',
        'is_active' => 'boolean',
        'shipping_fee' => 'decimal:2',
    ];

    protected $with = ['translations'];

    public array $translatedAttributes = ['name'];
}
