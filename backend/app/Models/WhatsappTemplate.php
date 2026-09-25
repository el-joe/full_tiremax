<?php

namespace App\Models;

use Astrotomic\Translatable\Contracts\Translatable as TranslatableContract;
use Astrotomic\Translatable\Translatable;
use Illuminate\Database\Eloquent\Model;

class WhatsappTemplate extends Model implements TranslatableContract
{
    use Translatable;

    protected $fillable = ['key', 'trigger_after_days', 'is_active', 'variables'];

    protected $casts = [
        'is_active' => 'boolean',
        'variables' => 'array',
    ];

    protected $with = ['translations'];

    public array $translatedAttributes = ['subject', 'body'];
}
