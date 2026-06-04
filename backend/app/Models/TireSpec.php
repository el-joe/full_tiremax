<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class TireSpec extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'product_id',
        'width',
        'aspect_ratio',
        'rim_diameter',
        'load_index',
        'speed_rating',
        'usage_type',
        'runflat',
    ];

    protected $casts = ['runflat' => 'boolean'];

    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }

    public function getSizeStringAttribute(): string
    {
        return "{$this->width}/{$this->aspect_ratio} R{$this->rim_diameter}";
    }
}
