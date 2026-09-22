<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\FlashSaleResource;
use App\Http\Resources\ProductResource;
use App\Models\FlashSale;
use App\Support\ApiResponse;
use Illuminate\Http\Request;

class FlashSaleController extends Controller
{
    /**
     * GET /v1/flash-sales
     * List all currently active flash sales with countdown info.
     */
    public function index()
    {
        $sales = FlashSale::active()
            ->withCount('products')
            ->orderBy('ends_at')
            ->get();

        return ApiResponse::success(FlashSaleResource::collection($sales));
    }

    /**
     * GET /v1/flash-sales/{flashSale}/products
     * List products in a specific (active) flash sale.
     *
     * Query params:
     *   type  = tire | battery
     *   per_page (default 15)
     */
    public function products(Request $request, FlashSale $flashSale)
    {
        $query = $flashSale->products()
            ->active()
            ->with(['translations', 'brand.translations', 'category.translations', 'images', 'badges', 'tireSpec', 'batterySpec'])
            ->withCount(['reviews as reviews_count' => fn($q) => $q->where('is_approved', true)]);

        if ($request->filled('type')) {
            $query->where('type', $request->input('type'));
        }

        $paginator = $query->paginate((int) $request->input('per_page', 15));

        // Inject the flash sale as the activeFlashSale relation on every product
        // so ProductResource can compute flash-sale price and countdown
        $paginator->getCollection()->each(
            fn($product) => $product->setRelation('activeFlashSale', collect([$flashSale]))
        );

        return ApiResponse::success(
            ProductResource::collection($paginator),
            null,
            200,
            [
                'flash_sale' => new FlashSaleResource($flashSale),
                'pagination' => [
                    'total' => $paginator->total(),
                    'per_page' => $paginator->perPage(),
                    'current_page' => $paginator->currentPage(),
                    'last_page' => $paginator->lastPage(),
                ],
            ]
        );
    }
}
