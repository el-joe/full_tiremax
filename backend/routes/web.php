<?php

use App\Livewire\Admin\Auth\Login;
use App\Livewire\Admin\Brands\BrandManager;
use App\Livewire\Admin\Branches\BranchManager;
use App\Livewire\Admin\Categories\CategoryManager;
use App\Livewire\Admin\Customers\CustomerManager;
use App\Livewire\Admin\DaftraLogs\DaftraLogManager;
use App\Livewire\Admin\Dashboard;
use App\Livewire\Admin\Fitments\FitmentManager;
use App\Livewire\Admin\FlashSales\FlashSaleManager;
use App\Livewire\Admin\Governorates\GovernorateManager;
use App\Livewire\Admin\Offers\OfferManager;
use App\Livewire\Admin\Orders\OrderManager;
use App\Livewire\Admin\PaymentGateways\PaymentGatewayManager;
use App\Livewire\Admin\Products\ProductForm;
use App\Livewire\Admin\Products\ProductManager;
use App\Livewire\Admin\Reviews\ReviewManager;
use App\Livewire\Admin\Services\ServiceManager;
use App\Livewire\Admin\Settings\SettingManager;
use App\Livewire\Admin\Vehicles\VehicleManager;
use App\Livewire\Admin\Vehicles\VehicleMakeManager;
use App\Livewire\Admin\Vehicles\VehicleModelManager;
use App\Livewire\Admin\WhatsappTemplates\WhatsappTemplateManager;
use App\Livewire\Admin\Bookings\BookingManager;
use App\Livewire\Admin\Admins\AdminManager;
use App\Livewire\Admin\Roles\RoleManager;
use App\Livewire\Admin\AuditLogs\AuditLogManager;
use Illuminate\Support\Facades\Route;

Route::get('/', fn() => redirect()->route('admin.dashboard'));

Route::prefix('admin')->name('admin.')->group(function () {
    Route::middleware('admin.guest')->group(function () {
        Route::get('login', Login::class)->name('login');
    });

    Route::middleware('admin')->group(function () {
        Route::get('/', Dashboard::class)->name('dashboard')->middleware('can:dashboard.view');
        Route::get('dashboard', Dashboard::class)->name('dashboard.index')->middleware('can:dashboard.view');

        Route::get('brands', BrandManager::class)->name('brands.index')->middleware('can:brands.view');
        Route::get('categories', CategoryManager::class)->name('categories.index')->middleware('can:categories.view');
        Route::get('branches', BranchManager::class)->name('branches.index')->middleware('can:branches.view');
        Route::get('governorates', GovernorateManager::class)->name('governorates.index')->middleware('can:governorates.view');
        Route::get('services', ServiceManager::class)->name('services.index')->middleware('can:services.view');

        Route::get('vehicles/makes', VehicleMakeManager::class)->name('vehicle-makes.index')->middleware('can:vehicles.view');
        Route::get('vehicles/models', VehicleModelManager::class)->name('vehicle-models.index')->middleware('can:vehicles.view');
        Route::get('vehicles', VehicleManager::class)->name('vehicles.index')->middleware('can:vehicles.view');

        Route::get('products', ProductManager::class)->name('products.index')->middleware('can:products.view');
        Route::get('products/create', ProductForm::class)->name('products.create')->middleware('can:products.create');
        Route::get('products/{productId}/edit', ProductForm::class)->name('products.edit')->middleware('can:products.update');

        Route::get('fitments', FitmentManager::class)->name('fitments.index')->middleware('can:fitments.view');

        Route::get('orders', OrderManager::class)->name('orders.index')->middleware('can:orders.view');
        Route::get('bookings', BookingManager::class)->name('bookings.index')->middleware('can:bookings.view');
        Route::get('customers', CustomerManager::class)->name('customers.index')->middleware('can:customers.view');
        Route::get('offers', OfferManager::class)->name('offers.index')->middleware('can:offers.view');
        Route::get('flash-sales', FlashSaleManager::class)->name('flash-sales.index')->middleware('can:flash_sales.view');
        Route::get('reviews', ReviewManager::class)->name('reviews.index')->middleware('can:reviews.view');
        Route::get('daftra-logs', DaftraLogManager::class)->name('daftra-logs.index')->middleware('can:daftra_logs.view');

        Route::get('payment-gateways', PaymentGatewayManager::class)->name('payment-gateways.index')->middleware('can:payment_gateways.view');

        Route::get('admins', AdminManager::class)->name('admins.index')->middleware('can:admins.view');
        Route::get('roles', RoleManager::class)->name('roles.index')->middleware('can:roles.view');
        Route::get('audit-logs', AuditLogManager::class)->name('audit-logs.index')->middleware('can:audit_logs.view');
        Route::get('settings', SettingManager::class)->name('settings.index')->middleware('can:settings.view');
        Route::get('whatsapp-templates', WhatsappTemplateManager::class)->name('whatsapp-templates.index')->middleware('can:whatsapp.view');

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
