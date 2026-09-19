<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\MorphTo;

class NotificationLog extends Model
{
    protected $fillable = ['channel', 'event', 'subject_type', 'subject_id', 'recipient', 'locale', 'status', 'error', 'meta'];
    protected $casts = ['meta' => 'array'];

    public function subject(): MorphTo
    {
        return $this->morphTo();
    }
}
