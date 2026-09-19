<?php

namespace App\Models\Concerns;

use App\Support\Phone;

/** Keeps `phone_normalized` in sync with the model's phone column. */
trait NormalizesPhone
{
    public static function bootNormalizesPhone(): void
    {
        static::saving(function ($model) {
            $col = $model->phoneSourceColumn();
            if ($model->isDirty($col) || $model->phone_normalized === null) {
                $model->phone_normalized = Phone::normalize($model->{$col});
            }
        });
    }

    public function phoneSourceColumn(): string
    {
        return 'phone';
    }
}
