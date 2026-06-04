<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;

class RegisterRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:120'],
            'phone' => ['required', 'string', 'max:20', 'unique:customers,phone'],
            'email' => ['nullable', 'email', 'max:120', 'unique:customers,email'],
            'password' => ['required', 'string', 'min:6', 'confirmed'],
            'address' => ['nullable', 'string', 'max:255'],
            'locale' => ['nullable', 'in:en,ar'],
        ];
    }
}
