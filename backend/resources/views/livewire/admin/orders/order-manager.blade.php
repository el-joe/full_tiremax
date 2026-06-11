<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.orders') }}</h2>
        <div class="flex gap-2 flex-wrap">
            <x-admin.select wire:model.live="statusFilter" :options="collect($statuses)->map(fn($st) => ['value' => $st, 'label' => $st])->all()" placeholder="All statuses" class="w-44" />
            <input type="search" wire:model.live.debounce.400ms="search" placeholder="{{ __('messages.admin.search') }}"
                class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
        </div>
    </div>
    <div class="bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden">
        <table class="w-full text-sm">
            <thead class="bg-stone-800/60">
                <tr>
                    <th class="px-4 py-3 text-start">Ref</th>
                    <th class="px-4 py-3 text-start">Customer</th>
                    <th class="px-4 py-3 text-start">Type</th>
                    <th class="px-4 py-3 text-start">Total</th>
                    <th class="px-4 py-3 text-start">Status</th>
                    <th class="px-4 py-3 text-start">Date</th>
                    <th class="px-4 py-3 text-start">Daftra</th>
                    <th class="px-4 py-3 text-end">{{ __('messages.admin.actions') }}</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-800">
                @forelse ($items as $o)
                    <tr class="hover:bg-stone-800/40">
                        <td class="px-4 py-3 font-mono text-yellow-500">{{ $o->reference }}</td>
                        <td class="px-4 py-3">{{ $o->customer_name }}
                            <div class="text-xs text-stone-400">{{ $o->customer_phone }}</div>
                        </td>
                        <td class="px-4 py-3 text-stone-400">{{ $o->type }}</td>
                        <td class="px-4 py-3 font-bold">{{ number_format($o->total) }} IQD</td>
                        <td class="px-4 py-3"><span
                                class="px-2 py-0.5 bg-stone-800 rounded-full text-xs">{{ $o->status }}</span></td>
                        <td class="px-4 py-3 text-stone-400 text-xs">{{ $o->created_at->format('Y-m-d H:i') }}</td>
                        <td class="px-4 py-3">
                            @if ($o->daftra_invoice_id)
                                @if ($o->daftra_invoice_url)
                                    <a href="{{ $o->daftra_invoice_url }}" target="_blank"
                                        class="px-2 py-0.5 rounded-full text-xs bg-emerald-500/20 text-emerald-400 font-mono hover:underline">#{{ $o->daftra_invoice_id }}</a>
                                @else
                                    <span class="px-2 py-0.5 rounded-full text-xs bg-emerald-500/20 text-emerald-400 font-mono">#{{ $o->daftra_invoice_id }}</span>
                                @endif
                            @else
                                <span class="text-stone-600 text-xs">—</span>
                            @endif
                        </td>
                        <td class="px-4 py-3 text-end">
                            <button wire:click="view({{ $o->id }})" class="text-yellow-500 text-xs me-3">View</button>
                            <button wire:click="confirmDelete({{ $o->id }})"
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

    @if ($viewing)
        <div class="fixed inset-0 bg-black/60 flex items-center justify-center z-40 p-4" wire:click.self="close">
            <div
                class="bg-stone-900 border border-stone-800 rounded-2xl w-full max-w-3xl p-6 space-y-4 max-h-[90vh] overflow-y-auto">
                <div class="flex justify-between items-start">
                    <div>
                        <h3 class="text-lg font-bold text-yellow-500">{{ $viewing->reference }}</h3>
                        <p class="text-xs text-stone-400">{{ $viewing->created_at->format('Y-m-d H:i') }}</p>
                    </div>
                    <button wire:click="close" class="text-stone-400 hover:text-stone-100">✕</button>
                </div>

                <div class="grid sm:grid-cols-2 gap-4 text-sm">
                    <div class="bg-stone-800/50 rounded-lg p-3">
                        <div class="text-xs text-stone-400">Customer</div>
                        <div class="font-bold">{{ $viewing->customer_name }}</div>
                        <div class="text-xs">{{ $viewing->customer_phone }}</div>
                        <div class="text-xs text-stone-400">{{ $viewing->customer_email }}</div>
                    </div>
                    <div class="bg-stone-800/50 rounded-lg p-3">
                        <div class="text-xs text-stone-400">Shipping</div>
                        <div>{{ optional($viewing->governorate)->name }}</div>
                        <div class="text-xs text-stone-400">{{ $viewing->shipping_address }}</div>
                    </div>
                </div>

                <div>
                    <h4 class="font-bold mb-2 text-stone-200">Items</h4>
                    <div class="bg-stone-800/30 rounded-lg divide-y divide-stone-800">
                        @foreach ($viewing->items as $it)
                            <div class="flex justify-between p-3 text-sm">
                                <div>
                                    <div class="font-bold">{{ optional($it->product)->name ?? $it->product_name }}</div>
                                    <div class="text-xs text-stone-400">SKU: {{ $it->sku }} · Qty: {{ $it->quantity }}</div>
                                </div>
                                <div class="font-bold">{{ number_format($it->line_total) }} IQD</div>
                            </div>
                        @endforeach
                    </div>
                </div>

                <div class="grid grid-cols-4 gap-3 text-sm">
                    <div class="bg-stone-800/50 rounded-lg p-2">
                        <div class="text-xs text-stone-400">Subtotal</div>{{ number_format($viewing->subtotal) }}
                    </div>
                    <div class="bg-stone-800/50 rounded-lg p-2">
                        <div class="text-xs text-stone-400">Shipping</div>{{ number_format($viewing->shipping_fee) }}
                    </div>
                    <div class="bg-stone-800/50 rounded-lg p-2">
                        <div class="text-xs text-stone-400">Discount</div>-{{ number_format($viewing->discount) }}
                    </div>
                    <div class="bg-yellow-500/20 rounded-lg p-2">
                        <div class="text-xs text-yellow-500">Total</div><span
                            class="font-bold">{{ number_format($viewing->total) }}</span>
                    </div>
                </div>

                @if ($viewing->daftra_invoice_id)
                    <div class="border-t border-stone-800 pt-3 flex items-center gap-3">
                        <span class="text-xs text-stone-400">Daftra Invoice:</span>
                        @if ($viewing->daftra_invoice_url)
                            <a href="{{ $viewing->daftra_invoice_url }}" target="_blank"
                                class="px-2 py-0.5 rounded-full text-xs bg-emerald-500/20 text-emerald-400 font-mono hover:underline">#{{ $viewing->daftra_invoice_id }}</a>
                        @else
                            <span class="px-2 py-0.5 rounded-full text-xs bg-emerald-500/20 text-emerald-400 font-mono">#{{ $viewing->daftra_invoice_id }}</span>
                        @endif
                    </div>
                @endif

                <div class="border-t border-stone-800 pt-3">
                    <h4 class="font-bold text-stone-200 mb-2">Change status</h4>
                    <div class="flex flex-wrap gap-2">
                        @foreach ($statuses as $st)
                            <button wire:click="changeStatus({{ $viewing->id }}, '{{ $st }}')"
                                class="px-3 py-1 rounded-full text-xs {{ $viewing->status === $st ? 'bg-yellow-500 text-stone-950 font-bold' : 'bg-stone-800 hover:bg-stone-700' }}">
                                {{ $st }}
                            </button>
                        @endforeach
                    </div>
                </div>
            </div>
        </div>
    @endif
</div>