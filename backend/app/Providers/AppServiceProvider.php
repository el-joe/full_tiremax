<?php

namespace App\Providers;

use App\Events\BookingCreated;
use App\Events\OrderPlaced;
use App\Listeners\PushBookingToDaftra;
use App\Listeners\PushOrderToDaftra;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void {}

    public function boot(): void
    {
        \Illuminate\Database\Eloquent\Model::preventLazyLoading(!app()->isProduction());
        Gate::before(function ($user, $ability) {
            if ($user instanceof \App\Models\Admin && $user->hasRole('super-admin')) {
                return true;
            }
            return null;
        });

        // Notification listeners (SendOrder/BookingNotifications) are auto-discovered from app/Listeners.
        Event::listen(OrderPlaced::class, PushOrderToDaftra::class);
        Event::listen(BookingCreated::class, PushBookingToDaftra::class);
    }
}
