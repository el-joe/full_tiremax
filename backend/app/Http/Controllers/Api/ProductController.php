<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\ProductResource;
use App\Models\Product;
use App\Services\ProductService;
use App\Support\ApiResponse;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function __construct(protected ProductService $service)
    {
    }

    public function index(Request $request)
    {
        $paginator = $this->service->paginate($request->all());

        return ApiResponse::success(
            ProductResource::collection($paginator),
            null,
            200,
            [
                'pagination' => [
                    'total' => $paginator->total(),
                    'per_page' => $paginator->perPage(),
                    'current_page' => $paginator->currentPage(),
                    'last_page' => $paginator->lastPage(),
                ],
            ]
        );
    }

    public function show(Request $request, Product $product)
    {
        $product->load(['brand', 'brand.translations', 'category', 'category.translations', 'images', 'badges', 'tireSpec', 'batterySpec', 'translations']);
        $this->service->trackView($product, optional($request->user())->id, $request->ip(), $request->userAgent());
        return ApiResponse::success(new ProductResource($product));
    }

    public function related(Product $product)
    {
        $related = $this->service->relatedProducts($product);
        return ApiResponse::success(ProductResource::collection($related));
    }
}
