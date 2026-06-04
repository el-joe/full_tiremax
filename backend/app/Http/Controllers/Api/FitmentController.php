<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\ProductResource;
use App\Models\Vehicle;
use App\Services\FitmentService;
use App\Support\ApiResponse;
use Illuminate\Http\Request;

class FitmentController extends Controller
{
    public function __construct(protected FitmentService $service)
    {
    }

    public function byVehicle(Request $request, Vehicle $vehicle)
    {
        $products = $this->service->productsForVehicle($vehicle, $request->all());
        return ApiResponse::success(ProductResource::collection($products));
    }

    public function bySize(Request $request)
    {
        $request->validate([
            'width' => ['required', 'integer'],
            'aspect_ratio' => ['required', 'integer'],
            'rim_diameter' => ['required', 'integer'],
        ]);
        $products = $this->service->productsBySize($request->only(['width', 'aspect_ratio', 'rim_diameter']));
        return ApiResponse::success(ProductResource::collection($products));
    }
}
