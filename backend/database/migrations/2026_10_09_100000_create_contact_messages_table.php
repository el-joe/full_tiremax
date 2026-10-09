<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Spatie\Permission\PermissionRegistrar;

return new class extends Migration
{
    private const GUARD = 'admin';

    public function up(): void
    {
        Schema::create('contact_messages', function (Blueprint $table) {
            $table->id();
            $table->foreignId('customer_id')->nullable()->constrained()->nullOnDelete();
            $table->string('name', 120);
            $table->string('phone', 30);
            $table->string('subject', 190);
            $table->text('message');
            $table->string('status', 20)->default('new')->index(); // new|read|replied|archived
            $table->text('admin_notes')->nullable();
            $table->string('ip_address', 45)->nullable();
            $table->timestamps();
        });

        // Permissions for existing databases.
        $now = now();
        $ids = [];
        foreach (['contact_messages.view', 'contact_messages.manage', 'contact_messages.delete'] as $name) {
            $existing = DB::table('permissions')->where('name', $name)->where('guard_name', self::GUARD)->value('id');
            $ids[$name] = $existing ?? DB::table('permissions')->insertGetId([
                'name' => $name, 'guard_name' => self::GUARD, 'created_at' => $now, 'updated_at' => $now,
            ]);
        }

        $roleTable = config('permission.table_names.role_has_permissions', 'role_has_permissions');
        $roles = DB::table('roles')->where('guard_name', self::GUARD)->whereIn('name', ['super-admin', 'support'])->pluck('id');
        foreach ($roles as $roleId) {
            foreach ($ids as $permId) {
                DB::table($roleTable)->insertOrIgnore(['permission_id' => $permId, 'role_id' => $roleId]);
            }
        }

        app(PermissionRegistrar::class)->forgetCachedPermissions();
    }

    public function down(): void
    {
        Schema::dropIfExists('contact_messages');

        $perms = DB::table('permissions')->where('guard_name', self::GUARD)->where('name', 'like', 'contact\_messages.%')->pluck('id');
        DB::table(config('permission.table_names.role_has_permissions', 'role_has_permissions'))->whereIn('permission_id', $perms)->delete();
        DB::table('permissions')->whereIn('id', $perms)->delete();

        app(PermissionRegistrar::class)->forgetCachedPermissions();
    }
};
