<?php

namespace Tests\Feature\Api;

use App\Models\Customer;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AuthApiTest extends TestCase
{
    use RefreshDatabase, ApiTestHelpers;

    private function registerPayload(array $o = []): array
    {
        return $o + ['name' => 'Ali', 'phone' => '07701234567', 'email' => 'ali@example.com', 'password' => 'secret12', 'password_confirmation' => 'secret12'];
    }

    public function test_register_returns_customer_and_token(): void
    {
        $this->postJson('/api/v1/auth/register', $this->registerPayload())
            ->assertCreated()
            ->assertJsonStructure(['success', 'message', 'data' => ['customer' => ['id', 'name', 'phone'], 'access_token', 'token_type', 'expires_in']]);
        $this->assertDatabaseHas('customers', ['phone' => '07701234567']);
    }

    public function test_register_validation_and_duplicate_phone(): void
    {
        $this->postJson('/api/v1/auth/register', [])->assertStatus(422)->assertJsonStructure(['success', 'message', 'errors' => ['name', 'phone', 'password']]);
        $this->postJson('/api/v1/auth/register', $this->registerPayload())->assertCreated();
        $this->postJson('/api/v1/auth/register', $this->registerPayload(['email' => 'b@example.com']))->assertStatus(422)->assertJsonValidationErrors('phone', 'errors');
        $this->postJson('/api/v1/auth/register', $this->registerPayload(['phone' => '07709999999', 'password_confirmation' => 'x']))->assertStatus(422);
    }

    public function test_login_by_phone_and_email_and_failures(): void
    {
        $c = Customer::factory()->create(['phone' => '07705555555', 'email' => 'c@example.com']);
        $this->postJson('/api/v1/auth/login', ['login' => '07705555555', 'password' => 'password'])
            ->assertOk()->assertJsonStructure(['data' => ['customer' => ['id'], 'access_token', 'token_type', 'expires_in']]);
        $this->postJson('/api/v1/auth/login', ['login' => 'c@example.com', 'password' => 'password'])->assertOk();
        $this->postJson('/api/v1/auth/login', ['login' => '07705555555', 'password' => 'wrong'])->assertStatus(401)->assertJsonPath('success', false);
        $this->postJson('/api/v1/auth/login', [])->assertStatus(422);
        $this->postJson('/api/v1/auth/login', ['login' => Customer::factory()->banned()->create()->phone, 'password' => 'password'])->assertStatus(403);
    }

    public function test_me_update_refresh_logout(): void
    {
        $c = Customer::factory()->create();
        $this->getJson('/api/v1/auth/me')->assertStatus(401);
        $h = $this->bearer($c);
        $this->getJson('/api/v1/auth/me', $h)->assertOk()->assertJsonPath('data.id', $c->id)->assertJsonStructure(['data' => ['id', 'name', 'phone', 'email']]);

        $this->putJson('/api/v1/auth/me', ['name' => 'New Name', 'locale' => 'en'], $h)->assertOk()->assertJsonPath('data.name', 'New Name');
        $this->putJson('/api/v1/auth/me', ['locale' => 'fr'], $h)->assertStatus(422);
        $this->forgetAuth();
        $this->putJson('/api/v1/auth/me', ['name' => 'x'])->assertStatus(401);
    }

    // JWTAuth keeps the previous request on a singleton, so refresh/logout each get a fresh test (and app).
    public function test_refresh_issues_a_new_token(): void
    {
        $this->postJson('/api/v1/auth/refresh')->assertStatus(401);
        $this->forgetAuth();
        $h = $this->bearer(Customer::factory()->create());
        $this->postJson('/api/v1/auth/refresh', [], $h)->assertOk()->assertJsonStructure(['data' => ['access_token', 'token_type', 'expires_in']]);
    }

    public function test_logout_requires_auth_and_invalidates_token(): void
    {
        $this->postJson('/api/v1/auth/logout')->assertStatus(401);
        $this->forgetAuth();
        $h = $this->bearer(Customer::factory()->create());
        $this->postJson('/api/v1/auth/logout', [], $h)->assertOk();
    }
}
