<?php

namespace App\Livewire\Admin;

use App\Models\Booking;
use App\Models\Customer;
use App\Models\Order;
use App\Models\Product;
use Livewire\Attributes\Layout;
use Livewire\Component;

class Dashboard extends Component
{
    use \App\Livewire\Concerns\AuthorizesAdmin;

    #[Layout('components.admin.layout', ['title' => null])]
    public function render()
    {
        $this->authorizePermission('dashboard.view');
        $stats = [
            'orders_today' => Order::whereDate('created_at', today())->count(),
            'orders_pending' => Order::where('status', Order::STATUS_PENDING)->count(),
            'revenue_month' => (float) Order::whereMonth('placed_at', now()->month)
                ->whereYear('placed_at', now()->year)
                ->whereNotIn('status', [Order::STATUS_CANCELLED, Order::STATUS_REFUNDED])
                ->sum('total'),
            'bookings_today' => Booking::whereDate('scheduled_at', today())->count(),
            'low_stock' => Product::where('stock', '>', 0)->whereColumn('stock', '<=', 'low_stock_threshold')->count(),
            'out_of_stock' => Product::where('stock', '<=', 0)->count(),
            'customers_total' => Customer::count(),
            'products_total' => Product::count(),
        ];

        $latestOrders = Order::with('customer')->latest()->limit(7)->get();
        $latestBookings = Booking::with(['customer', 'branch', 'service'])->latest('scheduled_at')->limit(7)->get();

        return view('livewire.admin.dashboard', compact('stats', 'latestOrders', 'latestBookings'));
    }
}
