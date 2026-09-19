<?php

namespace Tests\Feature\Admin;

use App\Models\Admin;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\PermissionRegistrar;

trait ActingAsAdmin
{
    /**
     * Create an admin (guard "admin") holding the given permissions and authenticate as it.
     *
     * @param  array<int, string>  $permissions
     */
    protected function actingAsAdmin(array $permissions = [], array $attributes = []): Admin
    {
        $admin = Admin::factory()->create($attributes);

        foreach ($permissions as $name) {
            Permission::findOrCreate($name, 'admin');
        }
        $admin->givePermissionTo($permissions);
        app(PermissionRegistrar::class)->forgetCachedPermissions();

        $this->actingAs($admin, 'admin');

        return $admin;
    }
}
