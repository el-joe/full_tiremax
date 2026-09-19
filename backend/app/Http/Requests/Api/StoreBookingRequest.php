<?php

namespace App\Http\Requests\Api;

use App\Support\Phone;
use Illuminate\Foundation\Http\FormRequest;

class StoreBookingRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        $guest = !auth('api')->check();
        $phoneRule = function ($attr, $value, $fail) {
            if ($value !== null && $value !== '' && !Phone::isValidIraqi($value)) {
                $fail(__('messages.invalid_phone'));
            }
        };

        return [
            'branch_id' => ['required', 'exists:branches,id'],
            'service_id' => ['required', 'exists:services,id'],
            'order_id' => ['nullable', 'exists:orders,id'],
            'scheduled_at' => ['required', 'date', 'after:now'],
            'customer_name' => [$guest ? 'required' : 'nullable', 'string', 'max:120'],
            'customer_phone' => [$guest ? 'required' : 'nullable', 'string', 'max:20', $phoneRule],
            'customer_email' => ['nullable', 'email', 'max:120'],
            'locale' => ['nullable', 'in:en,ar'],
            'customer_notes' => ['nullable', 'string', 'max:500'],
        ];
    }
}
