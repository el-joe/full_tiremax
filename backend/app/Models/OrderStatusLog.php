<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\MorphTo;

class OrderStatusLog extends Model
{
    protected $fillable = ['order_id', 'from_status', 'to_status', 'note', 'actor_type', 'actor_id'];

    public function order(): BelongsTo
    {
        return $this->belongsTo(Order::class);
    }

    public function actor(): MorphTo
    {
        return $this->morphTo();
    }
}
