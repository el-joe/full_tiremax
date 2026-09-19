<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AdminAuthenticate
{
    public function handle(Request $request, Closure $next)
    {
        if (!Auth::guard('admin')->check()) {
            return redirect()->route('admin.login');
        }
        $admin = Auth::guard('admin')->user();
        if (!$admin || !$admin->is_active || (method_exists($admin, 'trashed') && $admin->trashed())) {
            Auth::guard('admin')->logout();
            $request->session()->invalidate();
            $request->session()->regenerateToken();
            return redirect()->route('admin.login')->withErrors(['email' => __('messages.admin.account_inactive')]);
        }
        return $next($request);
    }
}
