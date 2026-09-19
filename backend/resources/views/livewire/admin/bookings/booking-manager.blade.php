<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.bookings') }}</h2>
        <div class="flex gap-2 flex-wrap items-center">
            <x-admin.filter-bar :active="$this->hasActiveFilters()" :total="$items->total()">
                <x-admin.select wire:model.live="statusFilter" :options="collect($statuses)->map(fn($st) => ['value' => $st, 'label' => $st])->all()" :searchable="false" placeholder="All statuses" class="w-40" />
                <x-admin.select wire:model.live="branchFilter" :options="$branches->map(fn($x) => ['value' => $x->id, 'label' => $x->name])->all()" :searchable="true" placeholder="All branches" class="w-44" />
                <x-admin.select wire:model.live="serviceFilter" :options="$services->map(fn($x) => ['value' => $x->id, 'label' => $x->name])->all()" :searchable="true" placeholder="All services" class="w-44" />
                <x-admin.select wire:model.live="quick" :options="[['value' => 'today', 'label' => 'Today'], ['value' => 'tomorrow', 'label' => 'Tomorrow'], ['value' => 'week', 'label' => 'This week']]" :searchable="false" placeholder="Any day" class="w-36" />
                <x-admin.select wire:model.live="customerKind" :options="[['value' => 'registered', 'label' => 'Registered'], ['value' => 'guest', 'label' => 'Guest']]" :searchable="false" placeholder="All customers" class="w-40" />
                <x-admin.date-range />
            </x-admin.filter-bar>
            
        </div>
    </div>
    <div class="bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden">
        <table class="w-full text-sm">
            <thead class="bg-stone-800/60">
                <tr>
                    <th class="px-4 py-3 text-start">Ref</th>
                    <th class="px-4 py-3 text-start">Customer</th>
                    <th class="px-4 py-3 text-start">Service</th>
                    <th class="px-4 py-3 text-start">Branch</th>
                    <th class="px-4 py-3 text-start">Scheduled</th>
                    <th class="px-4 py-3 text-start">Status</th>
                    <th class="px-4 py-3 text-start">Daftra</th>
                    <th class="px-4 py-3 text-end">{{ __('messages.admin.actions') }}</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-800">
                @forelse ($items as $b)
                    <tr class="hover:bg-stone-800/40">
                        <td class="px-4 py-3 font-mono text-yellow-500">{{ $b->reference }}</td>
                        <td class="px-4 py-3">{{ $b->customer_name ?? $b->customer?->name ?? '—' }} @if ($b->is_guest || !$b->customer_id) <span class="px-1.5 py-0.5 rounded bg-amber-500/20 text-amber-400 text-[10px] align-middle">Guest</span> @endif
                            <div class="text-xs text-stone-400">{{ $b->customer_phone ?? $b->customer?->phone }}</div>
                        </td>
                        <td class="px-4 py-3">{{ optional($b->service)->name }}</td>
                        <td class="px-4 py-3 text-stone-400">{{ optional($b->branch)->name }}</td>
                        <td class="px-4 py-3">{{ optional($b->scheduled_at)->format('Y-m-d H:i') }}</td>
                        <td class="px-4 py-3">
                            @can('bookings.change_status')
                            <x-admin.select
                                :options="collect($statuses)->map(fn($st) => ['value' => $st, 'label' => $st])->all()"
                                :value="$b->status"
                                :searchable="false"
                                :nullable="false"
                                class="w-36 text-xs"
                                x-on:select-change="$wire.changeStatus({{ $b->id }}, $event.detail.value)"
                            />
                            @else
                            <span class="text-xs">{{ $b->status }}</span>
                            @endcan
                        </td>
                        <td class="px-4 py-3">
                            @if ($b->daftra_invoice_id)
                                <span class="px-2 py-0.5 rounded-full text-xs bg-emerald-500/20 text-emerald-400 font-mono">#{{ $b->daftra_invoice_id }}</span>
                            @else
                                <span class="text-stone-600 text-xs">—</span>
                            @endif
                        </td>
                        <td class="px-4 py-3 text-end">@can('bookings.delete')
<button wire:click="confirmDelete({{ $b->id }})"
                                class="text-red-400 text-xs">{{ __('messages.admin.delete') }}</button>
@endcan</td>
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
