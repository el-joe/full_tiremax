<?php

namespace App\Livewire\Concerns;

use Livewire\Attributes\Url;
use Livewire\WithPagination;
use ReflectionProperty;

/**
 * Shared list behaviour for admin Livewire tables.
 *
 * Components declare:
 *   protected array $filterKeys = ['statusFilter', ...];  // public props that are filters
 *   protected array $sortable   = ['id', 'created_at'];   // whitelist of sortable columns
 */
trait WithCrudList
{
    use WithPagination;

    public const PER_PAGE_OPTIONS = WithCrudListOptions::PER_PAGE;

    #[Url(as: 'q', keep: false)]
    public string $search = '';

    #[Url(as: 'sort', keep: false)]
    public string $sortBy = 'id';

    #[Url(as: 'dir', keep: false)]
    public string $sortDir = 'desc';

    #[Url(as: 'per_page', keep: false)]
    public int $perPage = 20;

    public ?int $editingId = null;

    /** Any filter / search / perPage / sort change sends the user back to page 1. */
    public function updated($name, $value = null): void
    {
        $root = explode('.', (string) $name)[0];
        if (in_array($root, $this->filterKeys(), true) || in_array($root, ['search', 'perPage', 'sortBy', 'sortDir'], true)) {
            $this->resetPage();
        }
    }

    /** @return array<int, string> */
    protected function filterKeys(): array
    {
        return property_exists($this, 'filterKeys') ? $this->filterKeys : [];
    }

    /** @return array<int, string> */
    protected function sortableColumns(): array
    {
        return property_exists($this, 'sortable') ? $this->sortable : ['id'];
    }

    public function resetFilters(): void
    {
        $this->reset(['search', ...$this->filterKeys()]);
        $this->resetPage();
    }

    public function hasActiveFilters(): bool
    {
        foreach (['search', ...$this->filterKeys()] as $key) {
            $default = (new ReflectionProperty($this, $key))->getDefaultValue();
            $value = $this->{$key};
            if ($value === '' || $value === null) {
                if ($default !== '' && $default !== null) {
                    return true;
                }
                continue;
            }
            if ($value != $default) {
                return true;
            }
        }

        return false;
    }

    public function sort(string $column): void
    {
        if (! in_array($column, $this->sortableColumns(), true)) {
            return;
        }
        if ($this->sortBy === $column) {
            $this->sortDir = $this->sortDir === 'asc' ? 'desc' : 'asc';
        } else {
            $this->sortBy = $column;
            $this->sortDir = 'asc';
        }
        $this->resetPage();
    }

    /** Whitelisted page size. */
    public function pageSize(): int
    {
        return in_array($this->perPage, self::PER_PAGE_OPTIONS, true) ? $this->perPage : 20;
    }

    /** Apply the (validated) sort to a query. Invalid column falls back to $default. */
    protected function applySort($query, string $default = 'id', string $defaultDir = 'desc')
    {
        if (in_array($this->sortBy, $this->sortableColumns(), true)) {
            $col = $this->sortBy;
            $dir = $this->sortDir === 'asc' ? 'asc' : 'desc';
        } else {
            $col = $default;
            $dir = $defaultDir;
        }

        return $query->orderBy($col, $dir);
    }

    public function toast(string $message, string $icon = 'success'): void
    {
        $this->dispatch('toast', icon: $icon, title: $message);
    }
}
