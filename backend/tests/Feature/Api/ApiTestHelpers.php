<?php

namespace Tests\Feature\Api;

use App\Models\Customer;

trait ApiTestHelpers
{
    protected function bearer(Customer $c): array
    {
        return ['Authorization' => 'Bearer ' . auth('api')->login($c), 'Accept' => 'application/json'];
    }

    /** auth('api')->login() leaves the token on the shared JWT singleton; clear it before unauthenticated calls. */
    protected function forgetAuth(): void
    {
        $this->app['auth']->forgetGuards();
        \Tymon\JWTAuth\Facades\JWTAuth::unsetToken();
        $this->app->make('tymon.jwt')->unsetToken();
    }

    protected function guest(string $token = 'guest-token-0123456789abcdef'): array
    {
        return ['X-Guest-Token' => $token, 'Accept' => 'application/json'];
    }

    protected function envelope(): array
    {
        return ['success', 'message', 'data'];
    }
}
