<?php

namespace Tests\Feature\Admin;

use App\Livewire\Admin\Admins\AdminManager;
use App\Livewire\Admin\AuditLogs\AuditLogManager;
use App\Livewire\Admin\Roles\RoleManager;
use App\Models\Admin;
use App\Models\AuditLog;
use Database\Seeders\RolePermissionSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Spatie\Permission\Models\Role;
use Tests\TestCase;

class AdminsRolesTest extends TestCase
{
    use RefreshDatabase, ActingAsAdmin;

    private function superAdmin(): Admin
    {
        $this->seed(RolePermissionSeeder::class);
        $a = Admin::factory()->create();
        $a->assignRole('super-admin');
        $this->actingAs($a, 'admin');
        return $a;
    }

    public function test_admin_crud_and_soft_delete_restore(): void
    {
        $this->superAdmin();
        Livewire::test(AdminManager::class)->call('openCreate')
            ->set('form.name', 'Sam')->set('form.email', 's@x.com')->set('form.password', 'password1')
            ->set('form.roles', ['support'])->call('save')->assertHasNoErrors();
        $new = Admin::where('email', 's@x.com')->firstOrFail();
        $this->assertTrue($new->hasRole('support'));
        $this->assertDatabaseHas('audit_logs', ['action' => 'admin.created']);

        Livewire::test(AdminManager::class)->call('edit', $new->id)->set('form.name', 'Sam2')->call('save')->assertHasNoErrors();
        $this->assertSame('Sam2', $new->fresh()->name);

        Livewire::test(AdminManager::class)->call('toggleActive', $new->id);
        $this->assertFalse($new->fresh()->is_active);

        Livewire::test(AdminManager::class)->call('delete', $new->id);
        $this->assertSoftDeleted('admins', ['id' => $new->id]);
        Livewire::test(AdminManager::class)->call('restore', $new->id);
        $this->assertNotSoftDeleted('admins', ['id' => $new->id]);
    }

    public function test_password_required_on_create_min_8(): void
    {
        $this->superAdmin();
        Livewire::test(AdminManager::class)->call('openCreate')
            ->set('form.name', 'A')->set('form.email', 'a@x.com')->set('form.password', 'short')->call('save')
            ->assertHasErrors('form.password');
    }

    public function test_cannot_delete_or_deactivate_self(): void
    {
        $me = $this->superAdmin();
        $other = Admin::factory()->create();
        $other->assignRole('super-admin');
        Livewire::test(AdminManager::class)->call('delete', $me->id)->assertHasErrors();
        Livewire::test(AdminManager::class)->call('toggleActive', $me->id)->assertHasErrors();
        $this->assertNull($me->fresh()->deleted_at);
        $this->assertTrue($me->fresh()->is_active);
    }

    public function test_last_active_super_admin_protected(): void
    {
        $me = $this->superAdmin();
        $mgr = Admin::factory()->create();
        $mgr->givePermissionTo(\Spatie\Permission\Models\Permission::findOrCreate('admins.delete', 'admin'));
        $mgr->givePermissionTo(\Spatie\Permission\Models\Permission::findOrCreate('admins.update', 'admin'));
        $mgr->givePermissionTo(\Spatie\Permission\Models\Permission::findOrCreate('admins.view', 'admin'));
        $this->actingAs($mgr, 'admin');
        Livewire::test(AdminManager::class)->call('delete', $me->id)->assertHasErrors();
        Livewire::test(AdminManager::class)->call('toggleActive', $me->id)->assertHasErrors();
        $this->assertTrue($me->fresh()->hasRole('super-admin'));
        $this->assertNull($me->fresh()->deleted_at);
    }

    public function test_only_super_admin_can_assign_super_admin_role(): void
    {
        $this->seed(RolePermissionSeeder::class);
        $mgr = $this->actingAsAdmin(['admins.view', 'admins.create', 'admins.update']);
        Livewire::test(AdminManager::class)->call('openCreate')
            ->set('form.name', 'X')->set('form.email', 'x@x.com')->set('form.password', 'password1')
            ->set('form.roles', ['super-admin'])->call('save')->assertHasErrors('form.roles');
        $this->assertDatabaseMissing('admins', ['email' => 'x@x.com']);
    }

    public function test_role_assignment_requires_update_permission(): void
    {
        $this->seed(RolePermissionSeeder::class);
        $this->actingAsAdmin(['admins.view', 'admins.create']);
        Livewire::test(AdminManager::class)->call('openCreate')
            ->set('form.name', 'X')->set('form.email', 'x@x.com')->set('form.password', 'password1')
            ->set('form.roles', ['support'])->call('save')->assertForbidden();
    }

    public function test_admin_filters(): void
    {
        $this->superAdmin();
        Admin::factory()->create(['name' => 'Zed Findme']);
        Admin::factory()->inactive()->create(['name' => 'Off One']);
        Livewire::test(AdminManager::class)->set('search', 'Findme')->assertSee('Zed Findme')->assertDontSee('Off One');
        Livewire::test(AdminManager::class)->set('activeFilter', '0')->assertSee('Off One')->assertDontSee('Zed Findme');
    }

    public function test_role_matrix_sync_and_cache_flush(): void
    {
        $this->superAdmin();
        Livewire::test(RoleManager::class)->call('openCreate')
            ->set('name', 'sales-team')->set('permissions', ['orders.view', 'orders.export'])->call('save')->assertHasNoErrors();
        $role = Role::findByName('sales-team', 'admin');
        $this->assertEqualsCanonicalizing(['orders.view', 'orders.export'], $role->permissions->pluck('name')->all());

        Livewire::test(RoleManager::class)->call('edit', $role->id)
            ->call('toggleRow', 'brands')->call('toggleColumn', 'view')->call('save')->assertHasNoErrors();
        $names = $role->fresh()->permissions->pluck('name')->all();
        $this->assertContains('brands.delete', $names);
        $this->assertContains('customers.view', $names);
        $this->assertContains('orders.export', $names);
    }

    public function test_role_validation_and_super_admin_readonly(): void
    {
        $this->superAdmin();
        $super = Role::findByName('super-admin', 'admin');
        Livewire::test(RoleManager::class)->call('openCreate')->set('name', 'Bad Name')->call('save')->assertHasErrors('name');
        Livewire::test(RoleManager::class)->call('openCreate')->set('name', 'support')->call('save')->assertHasErrors('name');
        Livewire::test(RoleManager::class)->call('edit', $super->id)->assertHasErrors();
        Livewire::test(RoleManager::class)->call('delete', $super->id)->assertHasErrors();
        $this->assertDatabaseHas('roles', ['name' => 'super-admin']);
    }

    public function test_cannot_delete_role_with_admins_but_can_when_empty(): void
    {
        $this->superAdmin();
        $role = Role::create(['name' => 'temp', 'guard_name' => 'admin']);
        $a = Admin::factory()->create();
        $a->assignRole('temp');
        Livewire::test(RoleManager::class)->call('delete', $role->id)->assertHasErrors();
        $this->assertDatabaseHas('roles', ['name' => 'temp']);
        $a->removeRole('temp');
        Livewire::test(RoleManager::class)->call('delete', $role->id);
        $this->assertDatabaseMissing('roles', ['name' => 'temp']);
    }

    public function test_components_enforce_permissions(): void
    {
        $this->actingAsAdmin([]);
        Livewire::test(AdminManager::class)->assertForbidden();
        Livewire::test(RoleManager::class)->assertForbidden();
        Livewire::test(AuditLogManager::class)->assertForbidden();

        $this->actingAsAdmin(['admins.view', 'roles.view']);
        Livewire::test(AdminManager::class)->call('openCreate')->assertForbidden();
        Livewire::test(AdminManager::class)->call('delete', 1)->assertForbidden();
        Livewire::test(AdminManager::class)->call('toggleActive', 1)->assertForbidden();
        Livewire::test(AdminManager::class)->call('restore', 1)->assertForbidden();
        Livewire::test(RoleManager::class)->call('openCreate')->assertForbidden();
        Livewire::test(RoleManager::class)->call('delete', 1)->assertForbidden();
        Livewire::test(RoleManager::class)->call('save')->assertForbidden();
    }

    public function test_audit_log_filters(): void
    {
        $a = $this->actingAsAdmin(['audit_logs.view']);
        $al = AuditLog::create(['admin_id' => $a->id, 'action' => 'thing.alpha', 'subject_type' => Admin::class, 'subject_id' => 1]);
        $be = AuditLog::create(['admin_id' => null, 'action' => 'thing.beta']);
        $k = fn ($l) => 'wire:key="log-'.$l->id.'"';
        Livewire::test(AuditLogManager::class)->assertSeeHtml($k($al))->assertSeeHtml($k($be))
            ->set('actionFilter', 'thing.alpha')->assertSeeHtml($k($al))->assertDontSeeHtml($k($be))
            ->set('actionFilter', '')->set('adminFilter', $a->id)->assertSeeHtml($k($al))->assertDontSeeHtml($k($be))
            ->set('adminFilter', null)->set('subjectFilter', Admin::class)->assertSeeHtml($k($al))->assertDontSeeHtml($k($be))
            ->set('subjectFilter', '')->set('search', 'beta')->assertSeeHtml($k($be))->assertDontSeeHtml($k($al))
            ->set('search', '')->set('from', now()->addDay()->toDateString())->assertDontSeeHtml($k($al));
    }
}
