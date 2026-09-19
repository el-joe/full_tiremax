<?php

namespace App\Support;

class AdminPermissions
{
    /**
     * Module => list of actions. Permission name = "<module>.<action>".
     *
     * @return array<string, array<int, string>>
     */
    public static function groups(): array
    {
        $crud = ['view', 'create', 'update', 'delete'];

        return [
            'dashboard' => ['view'],
            'products' => [...$crud, 'import'],
            'brands' => $crud,
            'categories' => $crud,
            'fitments' => $crud,
            'vehicles' => $crud,
            'orders' => [...$crud, 'change_status', 'export'],
            'bookings' => [...$crud, 'change_status'],
            'customers' => [...$crud, 'ban'],
            'branches' => $crud,
            'governorates' => $crud,
            'services' => $crud,
            'offers' => $crud,
            'flash_sales' => $crud,
            'reviews' => [...$crud, 'moderate'],
            'daftra_logs' => ['view'],
            'whatsapp' => $crud,
            'payment_gateways' => $crud,
            'settings' => ['view', 'update'],
            'admins' => $crud,
            'roles' => $crud,
            'audit_logs' => ['view'],
        ];
    }

    /** @return array<int, string> */
    public static function all(): array
    {
        $out = [];
        foreach (static::groups() as $module => $actions) {
            foreach ($actions as $a) {
                $out[] = "$module.$a";
            }
        }
        return $out;
    }

    /** All permissions of a module, e.g. forModule('orders'). */
    public static function forModule(string $module): array
    {
        return array_map(fn ($a) => "$module.$a", static::groups()[$module] ?? []);
    }
}
