<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    private array $map = [
        'orders' => ['status', 'type', 'payment_status', 'created_at'],
        'bookings' => ['scheduled_at', 'status'],
        'customers' => ['is_active', 'is_banned'],
        'products' => ['is_active', 'is_featured', 'stock'],
    ];

    public function up(): void
    {
        foreach ($this->map as $table => $cols) {
            $existing = collect(Schema::getIndexes($table))->map(fn ($i) => $i['columns'])->all();
            Schema::table($table, function (Blueprint $t) use ($table, $cols, $existing) {
                foreach ($cols as $c) {
                    if (!Schema::hasColumn($table, $c)) continue;
                    if (collect($existing)->contains(fn ($x) => ($x[0] ?? null) === $c)) continue;
                    $t->index($c, "{$table}_{$c}_idx");
                }
            });
        }
    }

    public function down(): void
    {
        foreach ($this->map as $table => $cols) {
            Schema::table($table, function (Blueprint $t) use ($table, $cols) {
                foreach ($cols as $c) {
                    try { $t->dropIndex("{$table}_{$c}_idx"); } catch (\Throwable $e) {}
                }
            });
        }
    }
};
