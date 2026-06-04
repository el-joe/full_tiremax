<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AutomationSetting extends Model
{
    protected $fillable = ['customer_id', 'is_disabled'];
    protected $casts = ['is_disabled' => 'boolean'];
}
