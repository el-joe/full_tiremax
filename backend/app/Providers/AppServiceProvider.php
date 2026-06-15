<?php

namespace App\Providers;

use App\Events\BookingCreated;
use App\Events\OrderPlaced;
use App\Listeners\PushBookingToDaftra;
use App\Listeners\PushOrderToDaftra;
use App\Listeners\SendPostPurchaseMessages;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void {}

    public function boot(): void
    {
        Event::listen(OrderPlaced::class, PushOrderToDaftra::class);
        Event::listen(OrderPlaced::class, SendPostPurchaseMessages::class);
        Event::listen(BookingCreated::class, PushBookingToDaftra::class);
    }
}
