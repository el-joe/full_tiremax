<?php

namespace App\Models;

use Astrotomic\Translatable\Contracts\Translatable as TranslatableContract;
use Astrotomic\Translatable\Translatable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Fitment extends Model implements TranslatableContract
{
    use Translatable;

    protected $fillable = [
        'vehicle_id',
        'product_id',
        'year_from',
        'year_to',
        'trim',
        'is_alternative',
        'is_excluded',
        'is_oem',
    ];

    protected $casts = [
        'is_alternative' => 'boolean',
        'is_excluded' => 'boolean',
        'is_oem' => 'boolean',
    ];

    public array $translatedAttributes = ['notes'];

    public function vehicle(): BelongsTo
    {
        return $this->belongsTo(Vehicle::class);
    }

    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }
}
