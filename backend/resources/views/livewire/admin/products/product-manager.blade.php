<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.products') }}</h2>
        <div class="flex gap-2 flex-wrap">
            <x-admin.select wire:model.live="type" :options="[['value' => 'tire', 'label' => 'Tire'], ['value' => 'battery', 'label' => 'Battery']]" :searchable="false" placeholder="All types" class="w-40" />
            <x-admin.select wire:model.live="brandFilter" :options="$brands->map(fn($b) => ['value' => $b->id, 'label' => $b->name])->all()" placeholder="All brands" class="w-48" />
            <input type="search" wire:model.live.debounce.400ms="search" placeholder="{{ __('messages.admin.search') }}"
                class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
            <a href="{{ route('admin.products.create') }}"
                class="bg-yellow-500 text-stone-950 font-bold px-4 py-2 rounded-lg text-sm">+
                {{ __('messages.admin.add_new') }}</a>
        </div>
    </div>
    <div class="bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden">
        <table class="w-full text-sm">
            <thead class="bg-stone-800/60">
                <tr>
                    <th class="px-4 py-3 text-start">#</th>
                    <th class="px-4 py-3 text-start">SKU</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.name') }}</th>
                    <th class="px-4 py-3 text-start">Brand</th>
                    <th class="px-4 py-3 text-start">Type</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.price') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.stock') }}</th>
                    <th class="px-4 py-3 text-end">{{ __('messages.admin.actions') }}</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-800">
                @forelse ($items as $p)
                    <tr class="hover:bg-stone-800/40">
                        <td class="px-4 py-3 text-stone-400">{{ $p->id }}</td>
                        <td class="px-4 py-3 font-mono text-xs">{{ $p->sku }}</td>
                        <td class="px-4 py-3 font-bold">{{ $p->name }}
                            @if ($p->type === 'tire' && $p->tireSpec)
                                <div class="text-xs text-stone-400">{{ $p->tireSpec->size_string }}</div>
                            @endif
                        </td>
                        <td class="px-4 py-3 text-stone-400">{{ optional($p->brand)->name }}</td>
                        <td class="px-4 py-3 text-stone-400">{{ $p->type }}</td>
                        <td class="px-4 py-3">{{ number_format($p->effective_price) }} IQD</td>
                        <td class="px-4 py-3 {{ $p->stock <= $p->low_stock_threshold ? 'text-amber-400' : '' }}">
                            {{ $p->stock }}
                        </td>
                        <td class="px-4 py-3 text-end">
                            <button wire:click="toggleActive({{ $p->id }})"
                                class="text-xs me-2 {{ $p->is_active ? 'text-emerald-400' : 'text-stone-500' }}">
                                {{ $p->is_active ? __('messages.admin.active') : __('messages.admin.inactive') }}
                            </button>
                            <a href="{{ route('admin.products.edit', $p->id) }}"
                                class="text-yellow-500 text-xs me-3">{{ __('messages.admin.edit') }}</a>
                            <button wire:click="confirmDelete({{ $p->id }})"
                                class="text-red-400 text-xs">{{ __('messages.admin.delete') }}</button>
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="8" class="px-4 py-8 text-center text-stone-500">{{ __('messages.admin.no_data') }}</td>
                    </tr>
                @endforelse
            </tbody>
        </table>
        <div class="p-3">{{ $items->links() }}</div>
    </div>
</div>