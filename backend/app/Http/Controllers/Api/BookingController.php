<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\StoreBookingRequest;
use App\Http\Resources\BookingResource;
use App\Models\Booking;
use App\Models\Branch;
use App\Services\BookingService;
use App\Support\ApiException;
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
        $paginator = $this->service->paginateForCustomer($request->user(), $request->all());
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
        $booking = $this->service->create($request->user(), $request->validated());
        return ApiResponse::created(new BookingResource($booking), __('messages.booking_created'));
    }

    public function show(Request $request, Booking $booking)
    {
        if ($booking->customer_id !== $request->user()->id) {
            throw ApiException::forbidden();
        }
        $booking->load(['branch', 'service']);
        return ApiResponse::success(new BookingResource($booking));
    }

    public function cancel(Request $request, Booking $booking)
    {
        if ($booking->customer_id !== $request->user()->id) {
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
