<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\ServiceResource;
use App\Models\Service;
use App\Support\ApiResponse;

class ServiceController extends Controller
{
    public function index()
    {
        return ApiResponse::success(
            ServiceResource::collection(
                Service::where('is_active', true)->with('translations')->orderBy('sort_order')->get()
            )
        );
    }
}
