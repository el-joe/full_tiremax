<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;

class StoreAddressRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'full_name'      => ['required', 'string', 'max:255'],
            'phone'          => ['required', 'string', 'max:20'],
            'governorate_id' => ['required', 'integer', 'exists:governorates,id'],
            'city_id'        => ['required', 'integer', 'exists:cities,id'],
            'address'        => ['required', 'string', 'max:500'],
            'is_default'     => ['sometimes', 'boolean'],
        ];
    }
}
