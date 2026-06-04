<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\BrandResource;
use App\Models\Brand;
use App\Support\ApiResponse;

class BrandController extends Controller
{
    public function index()
    {
        $brands = Brand::where('is_active', true)->orderBy('sort_order')->get();
        return ApiResponse::success(BrandResource::collection($brands));
    }
}
