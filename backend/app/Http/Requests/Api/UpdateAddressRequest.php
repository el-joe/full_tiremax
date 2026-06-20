<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;

class UpdateAddressRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'full_name'      => ['sometimes', 'string', 'max:255'],
            'phone'          => ['sometimes', 'string', 'max:20'],
            'governorate_id' => ['sometimes', 'integer', 'exists:governorates,id'],
            'city_id'        => ['sometimes', 'integer', 'exists:cities,id'],
            'address'        => ['sometimes', 'string', 'max:500'],
            'is_default'     => ['sometimes', 'boolean'],
        ];
    }
}
