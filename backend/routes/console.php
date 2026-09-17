<?php

use App\Integrations\Daftra;
use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Schedule;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');

Schedule::command('daftra:sync-products')->everyThirtyMinutes()->when(fn () => Daftra::isEnabled());
Schedule::command('bookings:send-reminders')->dailyAt('09:00');
Schedule::command('whatsapp:order-notifications')->everyFiveMinutes();
