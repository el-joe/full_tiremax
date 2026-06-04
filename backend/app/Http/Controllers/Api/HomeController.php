<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\BrandResource;
use App\Http\Resources\GovernorateResource;
use App\Http\Resources\ProductResource;
use App\Models\Brand;
use App\Models\Governorate;
use App\Models\Product;
use App\Support\ApiResponse;

class HomeController extends Controller
{
    public function index()
    {
        $featured = Product::active()
            ->where('is_featured', true)
            ->with(['brand', 'images', 'badges', 'tireSpec', 'batterySpec'])
            ->orderBy('sort_order')
            ->limit(12)
            ->get();

        $bestSellers = Product::active()
            ->whereHas('badges', fn($q) => $q->where('badge', Product::BADGE_BEST_SELLER))
            ->with(['brand', 'images', 'badges'])
            ->limit(8)
            ->get();

        $newArrivals = Product::active()
            ->whereHas('badges', fn($q) => $q->where('badge', Product::BADGE_NEW))
            ->with(['brand', 'images', 'badges'])
            ->latest()
            ->limit(8)
            ->get();

        $offers = Product::active()
            ->whereNotNull('sale_price')
            ->with(['brand', 'images', 'badges'])
            ->limit(8)
            ->get();

        return ApiResponse::success([
            'featured' => ProductResource::collection($featured),
            'best_sellers' => ProductResource::collection($bestSellers),
            'new_arrivals' => ProductResource::collection($newArrivals),
            'offers' => ProductResource::collection($offers),
            'brands' => BrandResource::collection(Brand::where('is_active', true)->orderBy('sort_order')->get()),
            'governorates' => GovernorateResource::collection(Governorate::where('is_active', true)->orderBy('sort_order')->get()),
        ]);
    }
}
