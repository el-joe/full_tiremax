<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\StoreBookingRequest;
use App\Http\Resources\BookingResource;
use App\Models\Booking;
use App\Models\Branch;
use App\Services\BookingService;
use App\Support\Actor;
use App\Support\ApiException;
use App\Support\Phone;
use App\Support\ApiResponse;
use Carbon\Carbon;
use Illuminate\Http\Request;

class BookingController extends Controller
{
    public function __construct(protected BookingService $service)
    {
    }

    public function index(Request $request)
    {
        $paginator = $this->service->paginateForCustomer(Actor::fromRequest($request)->customer ?? throw ApiException::unauthorized(__('messages.unauthenticated')), $request->all());
        return ApiResponse::success(BookingResource::collection($paginator), null, 200, [
            'pagination' => [
                'total' => $paginator->total(),
                'per_page' => $paginator->perPage(),
                'current_page' => $paginator->currentPage(),
                'last_page' => $paginator->lastPage(),
            ],
        ]);
    }

    public function store(StoreBookingRequest $request)
    {
        $booking = $this->service->create(Actor::fromRequest($request)->require(), $request->validated());
        return ApiResponse::created(new BookingResource($booking), __('messages.booking_created'));
    }

    public function show(Request $request, string $bookingRef)
    {
        $actor = Actor::fromRequest($request);
        $booking = ctype_digit($bookingRef)
            ? Booking::find($bookingRef)
            : Booking::where('reference', $bookingRef)->first();

        $allowed = $booking && $actor->owns($booking);
        if ($booking && !$allowed && !ctype_digit($bookingRef) && $booking->customer_id === null && $request->filled('phone')) {
            $n = Phone::normalize((string) $request->query('phone'));
            $allowed = $n !== null && $booking->phone_normalized !== null && hash_equals($booking->phone_normalized, $n);
        }
        if (!$allowed) {
            throw ApiException::notFound();
        }

        $booking->load(['branch.translations', 'service.translations']);
        return ApiResponse::success(new BookingResource($booking));
    }

    public function cancel(Request $request, Booking $booking)
    {
        $actor = Actor::fromRequest($request)->require();
        if (!$actor->owns($booking)) {
            throw ApiException::forbidden();
        }
        $booking = $this->service->cancel($booking);
        return ApiResponse::success(new BookingResource($booking), __('messages.cancelled'));
    }

    public function availableSlots(Request $request, Branch $branch)
    {
        $request->validate(['date' => ['required', 'date']]);
        $slots = $this->service->availableSlots($branch, Carbon::parse($request->date));
        return ApiResponse::success($slots);
    }
}
