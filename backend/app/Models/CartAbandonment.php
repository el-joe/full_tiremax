<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CartAbandonment extends Model
{
    protected $fillable = ['cart_id', 'reminder_sent_at', 'recovered'];
    protected $casts = ['reminder_sent_at' => 'datetime', 'recovered' => 'boolean'];

    public function cart(): BelongsTo
    {
        return $this->belongsTo(Cart::class);
    }
}
