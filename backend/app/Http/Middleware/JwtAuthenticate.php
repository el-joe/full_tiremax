<?php

namespace App\Http\Middleware;

use App\Support\ApiResponse;
use Closure;
use Illuminate\Http\Request;
use Tymon\JWTAuth\Facades\JWTAuth;

class JwtAuthenticate
{
    public function handle(Request $request, Closure $next)
    {
        try {
            $user = JWTAuth::parseToken()->authenticate();
            if (!$user) {
                return ApiResponse::unauthorized(__('messages.unauthenticated'));
            }
        } catch (\Throwable $e) {
            return ApiResponse::unauthorized($e->getMessage());
        }
        return $next($request);
    }
}
