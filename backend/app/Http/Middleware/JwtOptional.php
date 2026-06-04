<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Tymon\JWTAuth\Facades\JWTAuth;

class JwtOptional
{
    public function handle(Request $request, Closure $next)
    {
        try {
            if ($request->bearerToken()) {
                JWTAuth::parseToken()->authenticate();
            }
        } catch (\Throwable $e) {
            // ignore — optional auth
        }
        return $next($request);
    }
}
