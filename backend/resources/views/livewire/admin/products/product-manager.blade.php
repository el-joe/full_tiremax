<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.products') }}</h2>
        <div class="flex gap-2 flex-wrap items-center">
            <x-admin.filter-bar :active="$this->hasActiveFilters()" :total="$items->total()">
                <x-admin.select wire:model.live="type" :options="[['value' => 'tire', 'label' => 'Tire'], ['value' => 'battery', 'label' => 'Battery']]" :searchable="false" placeholder="All types" class="w-36" />
                <x-admin.select wire:model.live="brandFilter" :options="$brands->map(fn($x) => ['value' => $x->id, 'label' => $x->name])->all()" :searchable="true" placeholder="All brands" class="w-44" />
                <x-admin.select wire:model.live="categoryFilter" :options="$categories->map(fn($x) => ['value' => $x->id, 'label' => $x->name])->all()" :searchable="true" placeholder="All categories" class="w-44" />
                <x-admin.select wire:model.live="activeFilter" :options="[['value' => '1', 'label' => 'Active'], ['value' => '0', 'label' => 'Inactive']]" :searchable="false" placeholder="All" class="w-36" />
                <x-admin.select wire:model.live="featuredFilter" :options="[['value' => '1', 'label' => 'Yes'], ['value' => '0', 'label' => 'No']]" :searchable="false" placeholder="Featured" class="w-36" />
                <x-admin.select wire:model.live="stockFilter" :options="[['value' => 'in', 'label' => 'In stock'], ['value' => 'low', 'label' => 'Low (<=5)'], ['value' => 'out', 'label' => 'Out of stock']]" :searchable="false" placeholder="Stock" class="w-36" />
                <x-admin.select wire:model.live="onSale" :options="[['value' => '1', 'label' => 'Yes'], ['value' => '0', 'label' => 'No']]" :searchable="false" placeholder="On sale" class="w-36" />
                <input type="number" wire:model.live.debounce.500ms="priceMin" placeholder="Min price" class="w-28 bg-stone-800 border border-stone-700 rounded-lg px-2 py-2 text-sm"><input type="number" wire:model.live.debounce.500ms="priceMax" placeholder="Max price" class="w-28 bg-stone-800 border border-stone-700 rounded-lg px-2 py-2 text-sm">
            </x-admin.filter-bar>
            @can('products.create')
<a href="{{ route('admin.products.create') }}"
                class="bg-yellow-500 text-stone-950 font-bold px-4 py-2 rounded-lg text-sm">+
                {{ __('messages.admin.add_new') }}</a>
@endcan
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
                    <th class="px-4 py-3 text-start">Daftra</th>
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
                        <td class="px-4 py-3">
                            @if ($p->daftra_id)
                                <span class="px-2 py-0.5 rounded-full text-xs bg-emerald-500/20 text-emerald-400 font-mono">#{{ $p->daftra_id }}</span>
                            @else
                                <span class="text-stone-600 text-xs">—</span>
                            @endif
                        </td>
                        <td class="px-4 py-3 text-end">
                            @can('products.update')
<button wire:click="toggleActive({{ $p->id }})"
                                class="text-xs me-2 {{ $p->is_active ? 'text-emerald-400' : 'text-stone-500' }}">
                                {{ $p->is_active ? __('messages.admin.active') : __('messages.admin.inactive') }}
                            </button>
@endcan
                            @can('products.update')
<a href="{{ route('admin.products.edit', $p->id) }}"
                                class="text-yellow-500 text-xs me-3">{{ __('messages.admin.edit') }}</a>
@endcan
                            @can('products.delete')
<button wire:click="confirmDelete({{ $p->id }})"
                                class="text-red-400 text-xs">{{ __('messages.admin.delete') }}</button>
@endcan
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="9" class="px-4 py-8 text-center text-stone-500">{{ __('messages.admin.no_data') }}</td>
                    </tr>
                @endforelse
            </tbody>
        </table>
        <div class="p-3">{{ $items->links() }}</div>
    </div>
</div>