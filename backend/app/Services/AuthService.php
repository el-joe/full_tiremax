<?php

namespace App\Services;

use App\Models\Customer;
use App\Support\ApiException;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Tymon\JWTAuth\Facades\JWTAuth;

class AuthService
{
    public function register(array $data): array
    {
        $customer = Customer::create([
            'name' => $data['name'],
            'phone' => $data['phone'],
            'email' => $data['email'] ?? null,
            'password' => $data['password'],
            'locale' => $data['locale'] ?? app()->getLocale(),
            'address' => $data['address'] ?? null,
        ]);

        $token = JWTAuth::fromUser($customer);

        $linked = app(GuestLinkService::class)->attach($customer, $data['guest_token'] ?? null);

        return $this->respondWithToken($customer, $token) + ['meta' => ['linked_orders' => $linked['orders'], 'linked_bookings' => $linked['bookings']]];
    }

    public function login(array $credentials): array
    {
        $field = filter_var($credentials['login'] ?? '', FILTER_VALIDATE_EMAIL) ? 'email' : 'phone';

        $customer = Customer::where($field, $credentials['login'])->first();

        if (!$customer || !Hash::check($credentials['password'], $customer->password)) {
            throw ApiException::unauthorized(__('messages.invalid_credentials'));
        }

        if (!$customer->is_active) {
            throw ApiException::forbidden(__('messages.account_disabled'));
        }

        $token = JWTAuth::fromUser($customer);

        $linked = app(GuestLinkService::class)->attach($customer, $credentials['guest_token'] ?? null);

        return $this->respondWithToken($customer, $token) + ['meta' => ['linked_orders' => $linked['orders'], 'linked_bookings' => $linked['bookings']]];
    }

    public function refresh(): array
    {
        $token = JWTAuth::parseToken()->refresh();
        $customer = JWTAuth::setToken($token)->authenticate();

        return $this->respondWithToken($customer, $token);
    }

    public function logout(): void
    {
        JWTAuth::parseToken()->invalidate();
    }

    public function update(Customer $customer, array $data): Customer
    {
        $payload = array_filter([
            'name' => $data['name'] ?? null,
            'email' => $data['email'] ?? null,
            'address' => $data['address'] ?? null,
            'locale' => $data['locale'] ?? null,
        ], fn($v) => $v !== null);

        if (!empty($data['password'])) {
            $payload['password'] = $data['password'];
        }

        $customer->update($payload);

        return $customer->fresh();
    }

    protected function respondWithToken(Customer $customer, string $token): array
    {
        return [
            'customer' => $customer,
            'access_token' => $token,
            'token_type' => 'bearer',
            'expires_in' => config('jwt.ttl') * 60,
        ];
    }
}
