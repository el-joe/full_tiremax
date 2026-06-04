<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.bookings') }}</h2>
        <div class="flex gap-2 flex-wrap">
            <x-admin.select
                wire:model.live="statusFilter"
                :options="collect($statuses)->map(fn($st) => ['value' => $st, 'label' => $st])->all()"
                placeholder="All statuses"
                class="w-44"
            />
            <x-admin.select
                wire:model.live="branchFilter"
                :options="$branches->map(fn($b) => ['value' => $b->id, 'label' => $b->name])->all()"
                placeholder="All branches"
                class="w-44"
            />
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
                    <th class="px-4 py-3 text-start">Service</th>
                    <th class="px-4 py-3 text-start">Branch</th>
                    <th class="px-4 py-3 text-start">Scheduled</th>
                    <th class="px-4 py-3 text-start">Status</th>
                    <th class="px-4 py-3 text-end">{{ __('messages.admin.actions') }}</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-800">
                @forelse ($items as $b)
                    <tr class="hover:bg-stone-800/40">
                        <td class="px-4 py-3 font-mono text-yellow-500">{{ $b->reference }}</td>
                        <td class="px-4 py-3">{{ optional($b->customer)->name }}
                            <div class="text-xs text-stone-400">{{ optional($b->customer)->phone }}</div>
                        </td>
                        <td class="px-4 py-3">{{ optional($b->service)->name }}</td>
                        <td class="px-4 py-3 text-stone-400">{{ optional($b->branch)->name }}</td>
                        <td class="px-4 py-3">{{ optional($b->scheduled_at)->format('Y-m-d H:i') }}</td>
                        <td class="px-4 py-3">
                            <x-admin.select
                                :options="collect($statuses)->map(fn($st) => ['value' => $st, 'label' => $st])->all()"
                                :value="$b->status"
                                :searchable="false"
                                :nullable="false"
                                class="w-36 text-xs"
                                x-on:select-change="$wire.changeStatus({{ $b->id }}, $event.detail.value)"
                            />
                        </td>
                        <td class="px-4 py-3 text-end"><button wire:click="confirmDelete({{ $b->id }})"
                                class="text-red-400 text-xs">{{ __('messages.admin.delete') }}</button></td>
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
</div>
