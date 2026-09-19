<?php

use App\Support\AdminPermissions;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Spatie\Permission\PermissionRegistrar;

return new class extends Migration
{
    private const GUARD = 'admin';

    /** old manage_X => modules that X now covers */
    private function map(): array
    {
        return [
            'dashboard' => ['dashboard'],
            'brands' => ['brands'],
            'categories' => ['categories'],
            'governorates' => ['governorates'],
            'branches' => ['branches'],
            'services' => ['services'],
            'vehicles' => ['vehicles'],
            'products' => ['products'],
            'fitments' => ['fitments'],
            'orders' => ['orders'],
            'bookings' => ['bookings'],
            'customers' => ['customers'],
            'offers' => ['offers', 'flash_sales'],
            'settings' => ['settings'],
            'admins' => ['admins', 'roles', 'audit_logs'],
        ];
    }

    public function up(): void
    {
        $now = now();
        $ids = [];
        foreach (AdminPermissions::all() as $name) {
            $existing = DB::table('permissions')->where('name', $name)->where('guard_name', self::GUARD)->value('id');
            $ids[$name] = $existing ?? DB::table('permissions')->insertGetId([
                'name' => $name, 'guard_name' => self::GUARD, 'created_at' => $now, 'updated_at' => $now,
            ]);
        }

        $roleTable = config('permission.table_names.role_has_permissions', 'role_has_permissions');
        foreach ($this->map() as $old => $modules) {
            $oldId = DB::table('permissions')->where('name', "manage_$old")->where('guard_name', self::GUARD)->value('id');
            if (!$oldId) {
                continue;
            }
            $roleIds = DB::table($roleTable)->where('permission_id', $oldId)->pluck('role_id');
            foreach ($roleIds as $roleId) {
                foreach ($modules as $module) {
                    foreach (AdminPermissions::forModule($module) as $perm) {
                        DB::table($roleTable)->insertOrIgnore(['permission_id' => $ids[$perm], 'role_id' => $roleId]);
                    }
                }
            }
        }

        // also direct grants to models
        $modelTable = config('permission.table_names.model_has_permissions', 'model_has_permissions');
        foreach ($this->map() as $old => $modules) {
            $oldId = DB::table('permissions')->where('name', "manage_$old")->where('guard_name', self::GUARD)->value('id');
            if (!$oldId) {
                continue;
            }
            foreach (DB::table($modelTable)->where('permission_id', $oldId)->get() as $row) {
                foreach ($modules as $module) {
                    foreach (AdminPermissions::forModule($module) as $perm) {
                        DB::table($modelTable)->insertOrIgnore([
                            'permission_id' => $ids[$perm], 'model_type' => $row->model_type, 'model_id' => $row->model_id,
                        ]);
                    }
                }
            }
        }

        DB::table('permissions')->where('guard_name', self::GUARD)->where('name', 'like', 'manage\_%')->delete();

        app(PermissionRegistrar::class)->forgetCachedPermissions();
    }

    public function down(): void
    {
        // Irreversible data migration: granular permissions are kept.
    }
};
