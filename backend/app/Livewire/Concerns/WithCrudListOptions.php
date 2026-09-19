<?php

namespace App\Livewire\Concerns;

/** Constants shared with blade components (traits cannot expose constants before PHP 8.2 access rules). */
final class WithCrudListOptions
{
    public const PER_PAGE = [10, 20, 50, 100];
}
