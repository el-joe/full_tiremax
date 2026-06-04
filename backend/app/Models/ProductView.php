<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProductView extends Model
{
    protected $fillable = ['product_id', 'customer_id', 'ip', 'user_agent'];
}
