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
        Gate::before(function ($user, $ability) {
            if ($user instanceof \App\Models\Admin && $user->hasRole('super-admin')) {
                return true;
            }
            return null;
        });

        Event::listen(OrderPlaced::class, PushOrderToDaftra::class);
        Event::listen(BookingCreated::class, PushBookingToDaftra::class);
    }
}
