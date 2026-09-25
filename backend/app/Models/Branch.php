<?php

namespace App\Models;

use Astrotomic\Translatable\Contracts\Translatable as TranslatableContract;
use Astrotomic\Translatable\Translatable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Branch extends Model implements TranslatableContract
{
    use \App\Models\Concerns\SearchesTranslations;
    use HasFactory, Translatable, SoftDeletes;

    protected $fillable = [
        'code',
        'phone',
        'email',
        'latitude',
        'longitude',
        'is_main',
        'is_active',
        'default_capacity',
        'auto_confirm_bookings',
    ];

    protected $casts = [
        'is_main' => 'boolean',
        'is_active' => 'boolean',
        'auto_confirm_bookings' => 'boolean',
        'latitude' => 'decimal:7',
        'longitude' => 'decimal:7',
    ];

    protected $with = ['translations'];

    public array $translatedAttributes = ['name', 'address', 'description'];

    public function schedules(): HasMany
    {
        return $this->hasMany(BranchSchedule::class);
    }

    public function services(): BelongsToMany
    {
        return $this->belongsToMany(Service::class, 'branch_service')
            ->withPivot(['price_override', 'is_active']);
    }

    public function bookings(): HasMany
    {
        return $this->hasMany(Booking::class);
    }
}
