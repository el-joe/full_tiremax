<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\StoreAddressRequest;
use App\Http\Requests\Api\UpdateAddressRequest;
use App\Http\Resources\AddressResource;
use App\Models\Address;
use App\Support\ApiResponse;
use Illuminate\Http\Request;

class AddressController extends Controller
{
    public function index(Request $request)
    {
        $addresses = $request->user()
            ->addresses()
            ->with(['governorate', 'governorate.translations', 'city'])
            ->orderByDesc('is_default')
            ->orderByDesc('created_at')
            ->get();

        return ApiResponse::success(AddressResource::collection($addresses));
    }

    public function store(StoreAddressRequest $request)
    {
        $data = $request->validated();
        $customer = $request->user();

        if (!empty($data['is_default'])) {
            $customer->addresses()->update(['is_default' => false]);
        }

        // Set first address as default automatically
        if ($customer->addresses()->count() === 0) {
            $data['is_default'] = true;
        }

        $address = $customer->addresses()->create($data);
        $address->load(['governorate', 'governorate.translations', 'city']);

        return ApiResponse::created(new AddressResource($address), __('messages.created'));
    }

    public function show(Request $request, Address $address)
    {
        if ($address->customer_id !== $request->user()->id) {
            return ApiResponse::forbidden();
        }

        $address->load(['governorate', 'governorate.translations', 'city']);
        return ApiResponse::success(new AddressResource($address));
    }

    public function update(UpdateAddressRequest $request, Address $address)
    {
        if ($address->customer_id !== $request->user()->id) {
            return ApiResponse::forbidden();
        }

        $data = $request->validated();

        if (!empty($data['is_default'])) {
            $request->user()->addresses()->where('id', '!=', $address->id)->update(['is_default' => false]);
        }

        $address->update($data);
        $address->load(['governorate', 'governorate.translations', 'city']);

        return ApiResponse::success(new AddressResource($address), __('messages.updated'));
    }

    public function destroy(Request $request, Address $address)
    {
        if ($address->customer_id !== $request->user()->id) {
            return ApiResponse::forbidden();
        }

        $wasDefault = $address->is_default;
        $address->delete();

        // Promote the next address as default
        if ($wasDefault) {
            $next = $request->user()->addresses()->first();
            $next?->update(['is_default' => true]);
        }

        return ApiResponse::success(null, __('messages.deleted'));
    }

    public function setDefault(Request $request, Address $address)
    {
        if ($address->customer_id !== $request->user()->id) {
            return ApiResponse::forbidden();
        }

        $request->user()->addresses()->update(['is_default' => false]);
        $address->update(['is_default' => true]);
        $address->load(['governorate', 'governorate.translations', 'city']);

        return ApiResponse::success(new AddressResource($address), __('messages.updated'));
    }
}
