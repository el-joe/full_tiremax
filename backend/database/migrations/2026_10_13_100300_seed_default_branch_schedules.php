<?php

use App\Models\Branch;
use App\Models\BranchSchedule;
use Illuminate\Database\Migrations\Migration;

/**
 * Branches with no weekly schedule have no bookable dates at all (every day reads as closed).
 * Give them a sensible default week: open 09:00-18:00, Friday closed. Admins can edit it from
 * Branches -> Edit -> Working hours.
 */
return new class extends Migration {
    public function up(): void
    {
        Branch::withTrashed()->doesntHave('schedules')->each(function (Branch $branch) {
            foreach (range(0, 6) as $dow) {
                BranchSchedule::create([
                    'branch_id' => $branch->id,
                    'day_of_week' => $dow,
                    'opens_at' => $dow === 5 ? null : '09:00',
                    'closes_at' => $dow === 5 ? null : '18:00',
                    'capacity' => $branch->default_capacity ?: 2,
                    'is_closed' => $dow === 5,
                ]);
            }
        });
    }

    public function down(): void
    {
        // schedules may have been edited by admins; nothing safe to revert
    }
};
