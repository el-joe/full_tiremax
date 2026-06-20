<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\CityResource;
use App\Models\City;
use App\Support\ApiResponse;

class CityController extends Controller
{
    public function byGovernorate(int $governorateId)
    {
        $cities = City::where('governorate_id', $governorateId)
            ->where('is_active', true)
            ->orderBy('sort_order')
            ->get();

        return ApiResponse::success(CityResource::collection($cities));
    }
}
