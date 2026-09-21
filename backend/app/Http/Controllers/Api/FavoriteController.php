<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\ProductResource;
use App\Models\Favorite;
use App\Models\Product;
use App\Support\ApiResponse;
use Illuminate\Http\Request;

class FavoriteController extends Controller
{
    public function index(Request $request)
    {
        $items = $request->user()->favorites()
            ->with(['product.brand', 'product.brand.translations', 'product.images', 'product.badges', 'product.translations'])
            ->latest()
            ->get()
            ->map(fn($f) => $f->product)
            ->filter();

        return ApiResponse::success(ProductResource::collection($items->values()));
    }

    public function toggle(Request $request, Product $product)
    {
        $favorite = Favorite::where('customer_id', $request->user()->id)
            ->where('product_id', $product->id)
            ->first();

        if ($favorite) {
            $favorite->delete();
            return ApiResponse::success(['favorited' => false], __('messages.deleted'));
        }

        Favorite::create([
            'customer_id' => $request->user()->id,
            'product_id' => $product->id,
        ]);
        return ApiResponse::created(['favorited' => true], __('messages.added'));
    }
}
