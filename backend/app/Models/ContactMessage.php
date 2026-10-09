<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ContactMessage extends Model
{
    public const STATUS_NEW = 'new';
    public const STATUS_READ = 'read';
    public const STATUS_REPLIED = 'replied';
    public const STATUS_ARCHIVED = 'archived';

    public const STATUSES = [self::STATUS_NEW, self::STATUS_READ, self::STATUS_REPLIED, self::STATUS_ARCHIVED];

    protected $fillable = [
        'customer_id',
        'name',
        'phone',
        'subject',
        'message',
        'status',
        'admin_notes',
        'ip_address',
    ];

    protected $attributes = [
        'status' => self::STATUS_NEW,
    ];

    public function customer(): BelongsTo
    {
        return $this->belongsTo(Customer::class);
    }
}
