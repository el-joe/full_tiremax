<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class SetLocale
{
    public function handle(Request $request, Closure $next)
    {
        $supported = config('translatable.locales', ['en', 'ar']);

        $isApi = $request->is('api/*') || $request->expectsJson();

        $locale = $isApi
            ? ($request->header('X-Locale')
                ?? $request->header('Accept-Language')
                ?? $request->query('locale')
                ?? session('locale')
                ?? config('app.locale'))
            : (session('locale')
                ?? $request->query('locale')
                ?? optional($request->user('admin'))->locale
                ?? $request->header('Accept-Language')
                ?? config('app.locale'));

        $locale = strtolower(substr((string) $locale, 0, 2));
        if (!in_array($locale, $supported, true)) {
            $locale = config('app.fallback_locale', 'en');
        }

        app()->setLocale($locale);

        return $next($request);
    }
}
