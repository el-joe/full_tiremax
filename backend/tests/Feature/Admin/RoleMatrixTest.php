<?php

namespace Tests\Feature\Admin;

use App\Models\Admin;
use Database\Seeders\RolePermissionSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

/** Every admin route x the three seeded roles; matches allowed/forbidden to the permission catalogue. */
class RoleMatrixTest extends TestCase
{
    use RefreshDatabase;

    public function test_route_by_role_matrix(): void
    {
        $this->seed(RolePermissionSeeder::class);
        $report = [];
        foreach (['super-admin', 'support', 'content-manager'] as $role) {
            $admin = Admin::factory()->create();
            $admin->assignRole($role);
            $this->actingAs($admin, 'admin');
            foreach (RbacTest::routes() as $name => $perm) {
                $expected = $admin->can($perm);
                $res = $this->get(route($name));
                $expected ? $res->assertOk() : $res->assertForbidden();
                $report[] = "$name|$role|" . ($expected ? '200' : '403');
            }
        }
        $this->assertNotEmpty($report);
    }
}
