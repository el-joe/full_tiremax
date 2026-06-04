<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class DaftraSyncLog extends Model
{
    protected $fillable = ['order_id', 'action', 'status', 'payload', 'response', 'attempts'];
    protected $casts = ['payload' => 'array', 'response' => 'array'];

    public function order(): BelongsTo
    {
        return $this->belongsTo(Order::class);
    }
}
