<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.bookings') }}</h2>
        <div class="flex gap-2 flex-wrap">
            <select wire:model.live="statusFilter"
                class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                <option value="">All statuses</option>
                @foreach ($statuses as $st) <option value="{{ $st }}">{{ $st }}</option> @endforeach
            </select>
            <select wire:model.live="branchFilter"
                class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                <option value="">All branches</option>
                @foreach ($branches as $b) <option value="{{ $b->id }}">{{ $b->name }}</option> @endforeach
            </select>
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
                            <select wire:change="changeStatus({{ $b->id }}, $event.target.value)"
                                class="bg-stone-800 border border-stone-700 rounded px-2 py-1 text-xs">
                                @foreach ($statuses as $st)
                                    <option value="{{ $st }}" @selected($b->status === $st)>{{ $st }}</option>
                                @endforeach
                            </select>
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