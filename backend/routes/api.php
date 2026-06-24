<?php

use App\Http\Controllers\Api\AddressController;
use App\Http\Controllers\Api\Auth\AuthController;
use App\Http\Controllers\Api\BookingController;
use App\Http\Controllers\Api\BrandController;
use App\Http\Controllers\Api\BranchController;
use App\Http\Controllers\Api\CartController;
use App\Http\Controllers\Api\CityController;
use App\Http\Controllers\Api\FavoriteController;
use App\Http\Controllers\Api\FitmentController;
use App\Http\Controllers\Api\FlashSaleController;
use App\Http\Controllers\Api\GovernorateController;
use App\Http\Controllers\Api\HomeController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\ProductController;
use App\Http\Controllers\Api\ReviewController;
use App\Http\Controllers\Api\ServiceController;
use App\Http\Controllers\Api\VehicleController;
use App\Integrations\Daftra;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {
    // Public ------------------------------------------------------------
    Route::get('/home', [HomeController::class, 'index']);

    Route::prefix('auth')->group(function () {
        Route::post('register', [AuthController::class, 'register']);
        Route::post('login', [AuthController::class, 'login']);
        Route::post('refresh', [AuthController::class, 'refresh']);

        Route::middleware('auth:api')->group(function () {
            Route::get('me', [AuthController::class, 'me']);
            Route::post('logout', [AuthController::class, 'logout']);
            Route::put('me', [AuthController::class, 'update']);
        });
    });

    // Catalog (public, optional auth) ----------------------------------
    Route::middleware('jwt.optional')->group(function () {
        Route::get('brands', [BrandController::class, 'index']);
        Route::get('branches', [BranchController::class, 'index']);
        Route::get('governorates', [GovernorateController::class, 'index']);
        Route::get('governorates/{governorate}/cities', [CityController::class, 'byGovernorate']);
        Route::get('services', [ServiceController::class, 'index']);

        Route::get('flash-sales', [FlashSaleController::class, 'index']);
        Route::get('flash-sales/{flashSale}/products', [FlashSaleController::class, 'products']);

        Route::get('vehicles/makes', [VehicleController::class, 'makes']);
        Route::get('vehicles/makes/{make}/models', [VehicleController::class, 'models']);
        Route::get('vehicles/models/{model}/years', [VehicleController::class, 'years']);
        Route::get('vehicles', [VehicleController::class, 'index']);
        Route::get('vehicles/{vehicle}', [VehicleController::class, 'show']);

        Route::get('products', [ProductController::class, 'index']);
        Route::get('products/{product}', [ProductController::class, 'show']);
        Route::get('products/{product}/related', [ProductController::class, 'related']);

        Route::get('fitments/sizes', [FitmentController::class, 'sizes']);
        Route::get('fitments/by-vehicle/{vehicle}', [FitmentController::class, 'byVehicle']);
        Route::get('fitments/by-size', [FitmentController::class, 'bySize']);

        Route::get('reviews/{product}', [ReviewController::class, 'index']);
    });

    // Authenticated --------------------------------------------------
    Route::get('bookings/branch/{branch}/slots', [BookingController::class, 'availableSlots']);
    Route::middleware('auth:api')->group(function () {
        // Cart
        Route::get('cart', [CartController::class, 'show']);
        Route::post('cart/items', [CartController::class, 'addItem']);
        Route::put('cart/items/{item}', [CartController::class, 'updateItem']);
        Route::delete('cart/items/{item}', [CartController::class, 'removeItem']);
        Route::delete('cart', [CartController::class, 'clear']);
        Route::post('cart/apply-offer', [CartController::class, 'applyOffer']);

        // Orders
        Route::get('orders', [OrderController::class, 'index']);
        Route::post('orders', [OrderController::class, 'store']); // checkout
        Route::get('orders/{order}', [OrderController::class, 'show']);
        Route::post('orders/{order}/cancel', [OrderController::class, 'cancel']);

        // Bookings
        Route::get('bookings', [BookingController::class, 'index']);
        Route::post('bookings', [BookingController::class, 'store']);
        Route::get('bookings/{booking}', [BookingController::class, 'show']);
        Route::post('bookings/{booking}/cancel', [BookingController::class, 'cancel']);

        // Addresses
        Route::get('addresses', [AddressController::class, 'index']);
        Route::post('addresses', [AddressController::class, 'store']);
        Route::get('addresses/{address}', [AddressController::class, 'show']);
        Route::put('addresses/{address}', [AddressController::class, 'update']);
        Route::delete('addresses/{address}', [AddressController::class, 'destroy']);
        Route::post('addresses/{address}/set-default', [AddressController::class, 'setDefault']);

        // Favorites
        Route::get('favorites', [FavoriteController::class, 'index']);
        Route::post('favorites/{product}/toggle', [FavoriteController::class, 'toggle']);

        // Reviews
        Route::post('reviews/{product}', [ReviewController::class, 'store']);
    });
});

Route::get('/daftra-test', function () {
    $daftra = new Daftra();
    return response()->json(['data' => $daftra->listProducts()]);
});
