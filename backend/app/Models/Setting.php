<?php

namespace App\Models;

use Astrotomic\Translatable\Contracts\Translatable as TranslatableContract;
use Astrotomic\Translatable\Translatable;
use Illuminate\Database\Eloquent\Model;

class Setting extends Model implements TranslatableContract
{
    use Translatable;

    protected $fillable = ['group', 'key', 'value', 'cast', 'is_translatable'];
    protected $casts = ['is_translatable' => 'boolean'];

    protected $with = ['translations'];

    public array $translatedAttributes = ['value'];

    protected static function booted(): void
    {
        static::saved(fn () => \App\Services\PublicSettings::flush());
        static::deleted(fn () => \App\Services\PublicSettings::flush());
    }

    public function getTypedValue(?string $locale = null): mixed
    {
        $raw = $this->is_translatable
            ? $this->translate($locale ?? app()->getLocale())?->value
            : $this->value;

        return match ($this->cast) {
            'int' => (int) $raw,
            'float' => (float) $raw,
            'bool' => filter_var($raw, FILTER_VALIDATE_BOOLEAN),
            'json' => json_decode((string) $raw, true),
            default => $raw,
        };
    }

    public static function getValue(string $group, string $key, mixed $default = null): mixed
    {
        $setting = static::where('group', $group)->where('key', $key)->first();

        return $setting?->getTypedValue() ?? $default;
    }
}
