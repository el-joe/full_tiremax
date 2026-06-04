<?php

namespace App\Models;

use Astrotomic\Translatable\Contracts\Translatable as TranslatableContract;
use Astrotomic\Translatable\Translatable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class VehicleModel extends Model implements TranslatableContract
{
    use Translatable;

    protected $table = 'vehicle_models';

    protected $fillable = ['vehicle_make_id', 'slug', 'is_active', 'sort_order'];
    protected $casts = ['is_active' => 'boolean'];

    public array $translatedAttributes = ['name'];

    public function make(): BelongsTo
    {
        return $this->belongsTo(VehicleMake::class, 'vehicle_make_id');
    }

    public function vehicles(): HasMany
    {
        return $this->hasMany(Vehicle::class);
    }
}
