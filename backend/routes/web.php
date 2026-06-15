<?php

use App\Livewire\Admin\Auth\Login;
use App\Livewire\Admin\Brands\BrandManager;
use App\Livewire\Admin\Branches\BranchManager;
use App\Livewire\Admin\Categories\CategoryManager;
use App\Livewire\Admin\Customers\CustomerManager;
use App\Livewire\Admin\Dashboard;
use App\Livewire\Admin\Fitments\FitmentManager;
use App\Livewire\Admin\FlashSales\FlashSaleManager;
use App\Livewire\Admin\Governorates\GovernorateManager;
use App\Livewire\Admin\Offers\OfferManager;
use App\Livewire\Admin\Orders\OrderManager;
use App\Livewire\Admin\Products\ProductForm;
use App\Livewire\Admin\Products\ProductManager;
use App\Livewire\Admin\Services\ServiceManager;
use App\Livewire\Admin\Vehicles\VehicleManager;
use App\Livewire\Admin\Vehicles\VehicleMakeManager;
use App\Livewire\Admin\Vehicles\VehicleModelManager;
use App\Livewire\Admin\Automation\AutomationManager;
use App\Livewire\Admin\Bookings\BookingManager;
use Illuminate\Support\Facades\Route;

Route::get('/', fn() => redirect()->route('admin.dashboard'));

Route::prefix('admin')->name('admin.')->group(function () {
    Route::middleware('admin.guest')->group(function () {
        Route::get('login', Login::class)->name('login');
    });

    Route::middleware('admin')->group(function () {
        Route::get('/', Dashboard::class)->name('dashboard');
        Route::get('dashboard', Dashboard::class)->name('dashboard.index');

        Route::get('brands', BrandManager::class)->name('brands.index');
        Route::get('categories', CategoryManager::class)->name('categories.index');
        Route::get('branches', BranchManager::class)->name('branches.index');
        Route::get('governorates', GovernorateManager::class)->name('governorates.index');
        Route::get('services', ServiceManager::class)->name('services.index');

        Route::get('vehicles/makes', VehicleMakeManager::class)->name('vehicle-makes.index');
        Route::get('vehicles/models', VehicleModelManager::class)->name('vehicle-models.index');
        Route::get('vehicles', VehicleManager::class)->name('vehicles.index');

        Route::get('products', ProductManager::class)->name('products.index');
        Route::get('products/create', ProductForm::class)->name('products.create');
        Route::get('products/{productId}/edit', ProductForm::class)->name('products.edit');

        Route::get('fitments', FitmentManager::class)->name('fitments.index');

        Route::get('orders', OrderManager::class)->name('orders.index');
        Route::get('bookings', BookingManager::class)->name('bookings.index');
        Route::get('customers', CustomerManager::class)->name('customers.index');
        Route::get('offers', OfferManager::class)->name('offers.index');
        Route::get('flash-sales', FlashSaleManager::class)->name('flash-sales.index');
        Route::get('automation', AutomationManager::class)->name('automation.index');

        Route::post('logout', function () {
            auth('admin')->logout();
            session()->invalidate();
            session()->regenerateToken();
            return redirect()->route('admin.login');
        })->name('logout');

        Route::post('locale/{locale}', function (string $locale) {
            if (in_array($locale, ['en', 'ar'], true)) {
                session(['locale' => $locale]);
            }
            return back();
        })->name('locale.switch');
    });
});
