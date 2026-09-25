<?php

namespace App\Models;

use Astrotomic\Translatable\Contracts\Translatable as TranslatableContract;
use Astrotomic\Translatable\Translatable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class VehicleMake extends Model implements TranslatableContract
{
    use \App\Models\Concerns\SearchesTranslations;
    use Translatable;

    protected $fillable = ['slug', 'logo', 'is_active', 'sort_order'];
    protected $casts = ['is_active' => 'boolean'];

    protected $with = ['translations'];

    public array $translatedAttributes = ['name'];

    public function models(): HasMany
    {
        return $this->hasMany(VehicleModel::class);
    }
}
