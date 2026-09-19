<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\PublicSettings;

class PublicSettingsController extends Controller
{
    public function show()
    {
        return response()->json(['data' => PublicSettings::get(app()->getLocale())]);
    }
}
