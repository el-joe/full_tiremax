<?php

namespace App\Http\Requests\Api;

use App\Support\Phone;
use Illuminate\Foundation\Http\FormRequest;

class StoreOrderRequest extends FormRequest
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
            'type' => ['required', 'in:basra,delivery'],
            'branch_id' => ['required_if:type,basra', 'nullable', 'exists:branches,id'],
            'governorate_id' => ['required_if:type,delivery', 'nullable', 'exists:governorates,id'],
            'payment_method' => ['nullable', 'in:cod,bank_transfer,paymob'],
            'customer_name' => [$guest ? 'required' : 'nullable', 'string', 'max:120'],
            'customer_phone' => [$guest ? 'required' : 'nullable', 'string', 'max:20', $phoneRule],
            'customer_email' => ['nullable', 'email', 'max:120'],
            'shipping_address' => ['required_if:type,delivery', 'nullable', 'string', 'max:255'],
            'notes' => ['nullable', 'string', 'max:500'],
            'offer_code' => ['nullable', 'string', 'max:50'],
            'locale' => ['nullable', 'in:en,ar'],
        ];
    }
}
