<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;

class StoreBookingRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'branch_id' => ['required', 'exists:branches,id'],
            'service_id' => ['required', 'exists:services,id'],
            'order_id' => ['nullable', 'exists:orders,id'],
            'scheduled_at' => ['required', 'date', 'after:now'],
            'customer_notes' => ['nullable', 'string', 'max:500'],
        ];
    }
}
