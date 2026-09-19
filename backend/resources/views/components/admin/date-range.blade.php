@props(['from' => 'from', 'to' => 'to'])
<div {{ $attributes->merge(['class' => 'flex items-center gap-1']) }}>
    <input type="date" wire:model.live="{{ $from }}" title="{{ __('messages.admin.from') }}"
        class="bg-stone-800 border border-stone-700 rounded-lg px-2 py-2 text-sm">
    <span class="text-stone-500 text-xs">&ndash;</span>
    <input type="date" wire:model.live="{{ $to }}" title="{{ __('messages.admin.to') }}"
        class="bg-stone-800 border border-stone-700 rounded-lg px-2 py-2 text-sm">
</div>
