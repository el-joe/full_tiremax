<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.flash_sales') }}</h2>
        <div class="flex gap-2">
            <input type="search" wire:model.live.debounce.400ms="search"
                placeholder="{{ __('messages.admin.search') }}"
                class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
            <button wire:click="openCreate"
                class="bg-yellow-500 text-stone-950 font-bold px-4 py-2 rounded-lg text-sm">
                + {{ __('messages.admin.add_new') }}
            </button>
        </div>
    </div>

    <div class="bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden">
        <table class="w-full text-sm">
            <thead class="bg-stone-800/60">
                <tr>
                    <th class="px-4 py-3 text-start">#</th>
                    <th class="px-4 py-3 text-start">Title</th>
                    <th class="px-4 py-3 text-start">Discount</th>
                    <th class="px-4 py-3 text-start">Window</th>
                    <th class="px-4 py-3 text-start">Status</th>
                    <th class="px-4 py-3 text-start">Products</th>
                    <th class="px-4 py-3 text-end">{{ __('messages.admin.actions') }}</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-800">
                @forelse ($items as $sale)
                    @php
                        $status    = $sale->status;
                        $badgeClass = match($status) {
                            'active'   => 'bg-emerald-500/20 text-emerald-400',
                            'upcoming' => 'bg-sky-500/20 text-sky-400',
                            'expired'  => 'bg-stone-700 text-stone-400',
                            default    => 'bg-red-500/20 text-red-400',
                        };
                    @endphp
                    <tr class="hover:bg-stone-800/40">
                        <td class="px-4 py-3 text-stone-400">{{ $sale->id }}</td>
                        <td class="px-4 py-3 font-bold">{{ $sale->title }}</td>
                        <td class="px-4 py-3 text-yellow-400 font-semibold">{{ $sale->discount_percent }}%</td>
                        <td class="px-4 py-3 text-xs text-stone-400">
                            {{ $sale->starts_at->format('Y-m-d H:i') }}
                            → {{ $sale->ends_at->format('Y-m-d H:i') }}
                        </td>
                        <td class="px-4 py-3">
                            <span class="px-2 py-0.5 rounded-full text-xs {{ $badgeClass }}">{{ $status }}</span>
                        </td>
                        <td class="px-4 py-3 text-stone-400">{{ $sale->products_count }}</td>
                        <td class="px-4 py-3 text-end">
                            <button wire:click="edit({{ $sale->id }})"
                                class="text-yellow-500 text-xs me-3">{{ __('messages.admin.edit') }}</button>
                            <button wire:click="confirmDelete({{ $sale->id }})"
                                class="text-red-400 text-xs">{{ __('messages.admin.delete') }}</button>
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="7" class="px-4 py-8 text-center text-stone-500">{{ __('messages.admin.no_data') }}</td>
                    </tr>
                @endforelse
            </tbody>
        </table>
        <div class="p-3">{{ $items->links() }}</div>
    </div>

    {{-- ── Create / Edit modal ─────────────────────────────────────────── --}}
    @if ($showForm)
        <div class="fixed inset-0 bg-black/60 flex items-center justify-center z-40 p-4"
            wire:click.self="$set('showForm', false)">
            <div class="bg-stone-900 border border-stone-800 rounded-2xl w-full max-w-2xl p-6 space-y-5 max-h-[90vh] overflow-y-auto">

                <div class="flex items-center justify-between">
                    <h3 class="text-lg font-bold">
                        {{ $editingId ? __('messages.admin.edit') : __('messages.admin.add_new') }} — {{ __('messages.admin.flash_sales') }}
                    </h3>
                    <button wire:click="$set('showForm', false)" class="text-stone-400 hover:text-stone-100">✕</button>
                </div>

                {{-- Basic info --}}
                <div class="grid sm:grid-cols-2 gap-3">
                    <div class="sm:col-span-2">
                        <label class="text-xs text-stone-400">Title</label>
                        <input wire:model="form.title"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                        @error('form.title') <p class="text-red-400 text-xs mt-1">{{ $message }}</p> @enderror
                    </div>
                    <div>
                        <label class="text-xs text-stone-400">Discount %</label>
                        <input type="number" step="0.01" min="1" max="100" wire:model="form.discount_percent"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                        @error('form.discount_percent') <p class="text-red-400 text-xs mt-1">{{ $message }}</p> @enderror
                    </div>
                    <div class="flex items-center gap-2 mt-5">
                        <label class="flex items-center gap-2">
                            <input type="checkbox" wire:model="form.is_active"
                                class="rounded bg-stone-800 border-stone-700 text-yellow-500">
                            <span class="text-sm">Active</span>
                        </label>
                    </div>
                    <div>
                        <label class="text-xs text-stone-400">Starts at</label>
                        <input type="datetime-local" wire:model="form.starts_at"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                        @error('form.starts_at') <p class="text-red-400 text-xs mt-1">{{ $message }}</p> @enderror
                    </div>
                    <div>
                        <label class="text-xs text-stone-400">Ends at</label>
                        <input type="datetime-local" wire:model="form.ends_at"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                        @error('form.ends_at') <p class="text-red-400 text-xs mt-1">{{ $message }}</p> @enderror
                    </div>
                </div>

                {{-- ── Product picker ──────────────────────────────────────── --}}
                <div class="border-t border-stone-800 pt-4 space-y-3">
                    <h4 class="text-sm font-semibold text-stone-200">Products in this flash sale
                        <span class="text-stone-500">({{ count($productIds) }})</span>
                    </h4>

                    {{-- Search --}}
                    <div class="relative" x-data="{ open: false }"
                        @focusin="open = true" @click.outside="open = false">
                        <input type="text" wire:model.live.debounce.300ms="productSearch"
                            placeholder="Search by name or SKU..."
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"
                            @focus="open = true">

                        @if ($searchResults->isNotEmpty())
                            <div x-show="open"
                                class="absolute z-50 top-full mt-1 left-0 right-0 bg-stone-800 border border-stone-700 rounded-lg shadow-2xl max-h-52 overflow-y-auto">
                                @foreach ($searchResults as $p)
                                    @if (! in_array($p->id, $productIds))
                                        <button type="button" wire:click="addProduct({{ $p->id }})"
                                            class="w-full flex items-center justify-between px-3 py-2 text-sm hover:bg-stone-700/60 text-left gap-2">
                                            <span>
                                                <span class="font-mono text-xs text-stone-400">{{ $p->sku }}</span>
                                                <span class="font-semibold"> {{ $p->name }}</span>
                                                @if ($p->brand) <span class="text-stone-400 text-xs">· {{ $p->brand->name }}</span> @endif
                                            </span>
                                            <span class="text-yellow-500 shrink-0">+ Add</span>
                                        </button>
                                    @endif
                                @endforeach
                            </div>
                        @elseif (mb_strlen(trim($productSearch)) >= 2 && $searchResults->isEmpty())
                            <div class="absolute z-50 top-full mt-1 left-0 right-0 bg-stone-800 border border-stone-700 rounded-lg px-3 py-3 text-sm text-stone-500">
                                No products found.
                            </div>
                        @endif
                    </div>

                    {{-- Selected products list --}}
                    @if ($selectedProducts->isNotEmpty())
                        <div class="space-y-1 max-h-48 overflow-y-auto pr-1">
                            @foreach ($selectedProducts as $p)
                                <div class="flex items-center justify-between bg-stone-800/60 rounded-lg px-3 py-2 text-sm">
                                    <span>
                                        <span class="font-mono text-xs text-stone-400">{{ $p->sku }}</span>
                                        <span class="font-semibold"> {{ $p->name }}</span>
                                        @if ($p->brand) <span class="text-stone-400 text-xs">· {{ $p->brand->name }}</span> @endif
                                    </span>
                                    <button type="button" wire:click="removeProduct({{ $p->id }})"
                                        class="text-red-400 hover:text-red-300 text-xs shrink-0 ms-2">Remove</button>
                                </div>
                            @endforeach
                        </div>
                    @else
                        <p class="text-xs text-stone-500">No products added yet. Search above to add products.</p>
                    @endif
                </div>

                {{-- Actions --}}
                <div class="flex justify-end gap-2 pt-2 border-t border-stone-800">
                    <button wire:click="$set('showForm', false)"
                        class="px-4 py-2 rounded-lg bg-stone-800 text-sm">{{ __('messages.admin.cancel') }}</button>
                    <button wire:click="save"
                        class="px-4 py-2 rounded-lg bg-yellow-500 text-stone-950 font-bold text-sm">{{ __('messages.admin.save') }}</button>
                </div>
            </div>
        </div>
    @endif
</div>
