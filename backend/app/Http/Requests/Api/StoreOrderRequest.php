<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;

class StoreOrderRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'type' => ['required', 'in:basra,delivery'],
            'branch_id' => ['required_if:type,basra', 'nullable', 'exists:branches,id'],
            'governorate_id' => ['required_if:type,delivery', 'nullable', 'exists:governorates,id'],
            'payment_method' => ['nullable', 'in:cod,card,transfer'],
            'customer_name' => ['nullable', 'string', 'max:120'],
            'customer_phone' => ['nullable', 'string', 'max:20'],
            'customer_email' => ['nullable', 'email', 'max:120'],
            'shipping_address' => ['required_if:type,delivery', 'nullable', 'string', 'max:255'],
            'notes' => ['nullable', 'string', 'max:500'],
            'discount' => ['nullable', 'numeric', 'min:0'],
            'installation_fee' => ['nullable', 'numeric', 'min:0'],
        ];
    }
}
