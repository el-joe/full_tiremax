<?php

namespace App\Models;

use Astrotomic\Translatable\Contracts\Translatable as TranslatableContract;
use Astrotomic\Translatable\Translatable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOneThrough;
use Illuminate\Database\Eloquent\SoftDeletes;

class Vehicle extends Model implements TranslatableContract
{
    use \App\Models\Concerns\SearchesTranslations;
    use Translatable, SoftDeletes;

    protected $fillable = [
        'vehicle_model_id',
        'year_from',
        'year_to',
        'trim_code',
        'engine',
        'is_active',
    ];

    protected $casts = ['is_active' => 'boolean'];

    protected $with = ['translations'];

    public array $translatedAttributes = ['trim_name', 'notes'];

    public function model(): BelongsTo
    {
        return $this->belongsTo(VehicleModel::class, 'vehicle_model_id');
    }

    public function make(): HasOneThrough
    {
        return $this->hasOneThrough(
            VehicleMake::class,
            VehicleModel::class,
            'id',                // VehicleModel.id matched by Vehicle.vehicle_model_id
            'id',                // VehicleMake.id matched by VehicleModel.vehicle_make_id
            'vehicle_model_id',  // local key on Vehicle
            'vehicle_make_id'    // local key on VehicleModel
        );
    }

    public function fitments(): HasMany
    {
        return $this->hasMany(Fitment::class);
    }
}
