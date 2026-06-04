<?php

namespace App\Http\Controllers\Api\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\LoginRequest;
use App\Http\Requests\Api\RegisterRequest;
use App\Http\Requests\Api\UpdateProfileRequest;
use App\Http\Resources\CustomerResource;
use App\Services\AuthService;
use App\Support\ApiResponse;

class AuthController extends Controller
{
    public function __construct(protected AuthService $auth)
    {
    }

    public function register(RegisterRequest $request)
    {
        $payload = $this->auth->register($request->validated());
        return ApiResponse::created([
            'customer' => new CustomerResource($payload['customer']),
            'access_token' => $payload['access_token'],
            'token_type' => $payload['token_type'],
            'expires_in' => $payload['expires_in'],
        ], __('messages.registered'));
    }

    public function login(LoginRequest $request)
    {
        $payload = $this->auth->login($request->validated());
        return ApiResponse::success([
            'customer' => new CustomerResource($payload['customer']),
            'access_token' => $payload['access_token'],
            'token_type' => $payload['token_type'],
            'expires_in' => $payload['expires_in'],
        ], __('messages.logged_in'));
    }

    public function refresh()
    {
        $payload = $this->auth->refresh();
        return ApiResponse::success([
            'access_token' => $payload['access_token'],
            'token_type' => $payload['token_type'],
            'expires_in' => $payload['expires_in'],
        ]);
    }

    public function me()
    {
        return ApiResponse::success(new CustomerResource(auth()->user()));
    }

    public function update(UpdateProfileRequest $request)
    {
        $customer = $this->auth->update($request->user(), $request->validated());
        return ApiResponse::success(new CustomerResource($customer), __('messages.updated'));
    }

    public function logout()
    {
        $this->auth->logout();
        return ApiResponse::success(null, __('messages.logged_out'));
    }
}
