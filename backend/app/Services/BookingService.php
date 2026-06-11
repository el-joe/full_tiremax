<?php

namespace App\Services;

use App\Events\BookingCreated;
use App\Models\Booking;
use App\Models\Branch;
use App\Models\Customer;
use App\Models\Service;
use App\Support\ApiException;
use Carbon\Carbon;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class BookingService
{
    public function paginateForCustomer(Customer $customer, array $filters = []): LengthAwarePaginator
    {
        return $customer->bookings()
            ->with(['branch', 'service'])
            ->latest('scheduled_at')
            ->paginate((int) ($filters['per_page'] ?? 15));
    }

    public function create(Customer $customer, array $data): Booking
    {
        return DB::transaction(function () use ($customer, $data) {
            $branch = Branch::findOrFail($data['branch_id']);
            $service = Service::findOrFail($data['service_id']);

            $scheduledAt = Carbon::parse($data['scheduled_at']);

            $this->ensureCapacity($branch, $scheduledAt, $service->duration_minutes);

            $booking = Booking::create([
                'reference' => 'BK-' . now()->format('ymd') . '-' . strtoupper(Str::random(5)),
                'customer_id' => $customer->id,
                'branch_id' => $branch->id,
                'service_id' => $service->id,
                'order_id' => $data['order_id'] ?? null,
                'scheduled_at' => $scheduledAt,
                'duration_minutes' => $service->duration_minutes,
                'status' => $branch->auto_confirm_bookings
                    ? Booking::STATUS_CONFIRMED
                    : Booking::STATUS_PENDING,
                'customer_notes' => $data['customer_notes'] ?? null,
            ]);

            BookingCreated::dispatch($booking);

            return $booking->load(['branch', 'service']);
        });
    }

    public function cancel(Booking $booking): Booking
    {
        if (in_array($booking->status, [Booking::STATUS_COMPLETED, Booking::STATUS_CANCELLED], true)) {
            throw ApiException::badRequest(__('messages.cannot_cancel'));
        }
        $booking->update(['status' => Booking::STATUS_CANCELLED]);
        return $booking->fresh();
    }

    public function availableSlots(Branch $branch, Carbon $day): array
    {
        $dow = (int) $day->dayOfWeek;
        $schedule = $branch->schedules()->where('day_of_week', $dow)->first();

        if (!$schedule || $schedule->is_closed || !$schedule->opens_at || !$schedule->closes_at) {
            return [];
        }

        $opens = $day->copy()->setTimeFromTimeString($schedule->opens_at);
        $closes = $day->copy()->setTimeFromTimeString($schedule->closes_at);
        $step = 30; // minutes

        $slots = [];
        for ($t = $opens->copy(); $t->lt($closes); $t->addMinutes($step)) {
            $count = Booking::where('branch_id', $branch->id)
                ->whereIn('status', [Booking::STATUS_PENDING, Booking::STATUS_CONFIRMED, Booking::STATUS_IN_PROGRESS])
                ->whereBetween('scheduled_at', [$t->copy(), $t->copy()->addMinutes($step)->subSecond()])
                ->count();
            $slots[] = [
                'time' => $t->format('H:i'),
                'available' => $count < $schedule->capacity,
                'capacity' => $schedule->capacity,
                'booked' => $count,
            ];
        }
        return $slots;
    }

    protected function ensureCapacity(Branch $branch, Carbon $at, int $durationMinutes): void
    {
        $dow = (int) $at->dayOfWeek;
        $schedule = $branch->schedules()->where('day_of_week', $dow)->first();

        if (!$schedule || $schedule->is_closed) {
            throw ApiException::badRequest(__('messages.branch_closed'));
        }

        $end = $at->copy()->addMinutes($durationMinutes);

        $count = Booking::where('branch_id', $branch->id)
            ->whereIn('status', [Booking::STATUS_PENDING, Booking::STATUS_CONFIRMED, Booking::STATUS_IN_PROGRESS])
            ->where(function ($q) use ($at, $end) {
                $q->whereBetween('scheduled_at', [$at, $end->copy()->subSecond()])
                    ->orWhereRaw(
                        'DATE_ADD(scheduled_at, INTERVAL duration_minutes MINUTE) > ? AND scheduled_at < ?',
                        [$at, $end]
                    );
            })
            ->count();

        if ($count >= $schedule->capacity) {
            throw ApiException::badRequest(__('messages.slot_full'));
        }
    }
}
