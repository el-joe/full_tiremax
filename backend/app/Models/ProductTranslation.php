<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProductTranslation extends Model
{
    public $timestamps = false;
    protected $fillable = [
        'name',
        'short_description',
        'description',
        'pattern_name',
        'usage_notes',
        'meta_title',
        'meta_description',
    ];
}
