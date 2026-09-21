<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\GovernorateResource;
use App\Models\Governorate;
use App\Support\ApiResponse;

class GovernorateController extends Controller
{
    public function index()
    {
        $items = Governorate::where('is_active', true)->with('translations')->orderBy('sort_order')->get();
        return ApiResponse::success(GovernorateResource::collection($items));
    }
}
