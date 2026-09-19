<?php

namespace App\Livewire\Admin\Auth;

use Illuminate\Support\Facades\Auth;
use Livewire\Attributes\Layout;
use Livewire\Component;

class Login extends Component
{
    public string $email = '';
    public string $password = '';
    public bool $remember = false;

    public function submit(): mixed
    {
        $data = $this->validate([
            'email' => ['required', 'email'],
            'password' => ['required', 'string'],
        ]);

        $existing = \App\Models\Admin::where('email', $data['email'])->first();
        if ($existing && !$existing->is_active && \Illuminate\Support\Facades\Hash::check($data['password'], $existing->password)) {
            $this->addError('email', __('messages.admin.account_inactive'));
            return null;
        }

        if (
            !Auth::guard('admin')->attempt(
                ['email' => $data['email'], 'password' => $data['password'], 'is_active' => true],
                $this->remember
            )
        ) {
            $this->addError('email', __('messages.admin.invalid_login'));
            return null;
        }

        Auth::guard('admin')->user()->update(['last_login_at' => now()]);

        session()->regenerate();

        return redirect()->intended(route('admin.dashboard'));
    }

    #[Layout('components.admin.base')]
    public function render()
    {
        return view('livewire.admin.auth.login');
    }
}
