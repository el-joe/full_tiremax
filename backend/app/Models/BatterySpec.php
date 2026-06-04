<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class BatterySpec extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'product_id',
        'voltage',
        'ampere_hour',
        'cca',
        'battery_type',
        'terminal_position',
        'size_code',
    ];

    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }
}
