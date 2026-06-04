<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ProductBadge extends Model
{
    public $timestamps = false;
    protected $fillable = ['product_id', 'badge'];

    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }
}
