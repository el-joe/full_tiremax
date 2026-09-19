@props([
    'active' => false,
    'total' => null,
    'search' => true,
    'perPage' => true,
])
<div {{ $attributes->merge(['class' => 'flex flex-wrap items-center gap-2']) }} data-filter-bar>
    @if ($search)
        <input type="search" wire:model.live.debounce.400ms="search" placeholder="{{ __('messages.admin.search') }}"
            class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
    @endif
    {{ $slot }}
    @if ($perPage)
        <select wire:model.live="perPage" title="{{ __('messages.admin.per_page') }}"
            class="bg-stone-800 border border-stone-700 rounded-lg px-2 py-2 text-sm">
            @foreach (\App\Livewire\Concerns\WithCrudListOptions::PER_PAGE as $n)
                <option value="{{ $n }}">{{ $n }}</option>
            @endforeach
        </select>
    @endif
    @if ($active)
        <button type="button" wire:click="resetFilters"
            class="px-3 py-2 text-sm rounded-lg border border-stone-600 text-stone-300 hover:bg-stone-800">{{ __('messages.admin.reset') }}</button>
    @endif
    @if (! is_null($total))
        <span class="text-xs text-stone-400 px-1">{{ __('messages.admin.results_count', ['count' => $total]) }}</span>
    @endif
</div>
