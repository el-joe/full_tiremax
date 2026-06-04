<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateProfileRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        $id = optional($this->user())->id;
        return [
            'name' => ['sometimes', 'string', 'max:120'],
            'email' => ['sometimes', 'nullable', 'email', 'max:120', Rule::unique('customers', 'email')->ignore($id)],
            'address' => ['sometimes', 'nullable', 'string', 'max:255'],
            'locale' => ['sometimes', 'in:en,ar'],
            'password' => ['sometimes', 'string', 'min:6', 'confirmed'],
        ];
    }
}
