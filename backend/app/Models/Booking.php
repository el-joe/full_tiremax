<?php

namespace App\Models;

use App\Models\Concerns\NormalizesPhone;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Booking extends Model
{
    use HasFactory, NormalizesPhone;

    public function phoneSourceColumn(): string
    {
        return 'customer_phone';
    }

    public const STATUS_PENDING = 'pending';
    public const STATUS_CONFIRMED = 'confirmed';
    public const STATUS_IN_PROGRESS = 'in_progress';
    public const STATUS_COMPLETED = 'completed';
    public const STATUS_CANCELLED = 'cancelled';
    public const STATUS_NO_SHOW = 'no_show';

    protected $fillable = [
        'reference',
        'customer_id',
        'customer_name',
        'customer_phone',
        'customer_email',
        'customer_locale',
        'is_guest',
        'guest_token',
        'phone_normalized',
        'branch_id',
        'service_id',
        'order_id',
        'scheduled_at',
        'duration_minutes',
        'status',
        'customer_notes',
        'admin_notes',
        'daftra_invoice_id',
    ];

    protected $hidden = ['guest_token'];

    protected $casts = [
        'is_guest' => 'boolean',
        'scheduled_at' => 'datetime',
    ];

    public function customer(): BelongsTo
    {
        return $this->belongsTo(Customer::class);
    }

    public function branch(): BelongsTo
    {
        return $this->belongsTo(Branch::class);
    }

    public function service(): BelongsTo
    {
        return $this->belongsTo(Service::class);
    }

    public function order(): BelongsTo
    {
        return $this->belongsTo(Order::class);
    }
}
