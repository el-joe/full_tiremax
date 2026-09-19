<?php

namespace App\Livewire\Concerns;

trait AuthorizesAdmin
{
    protected function authorizePermission(string $permission): void
    {
        abort_unless(auth('admin')->user()?->can($permission), 403);
    }
}
