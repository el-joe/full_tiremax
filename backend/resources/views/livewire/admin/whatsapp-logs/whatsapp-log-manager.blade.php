<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.whatsapp_logs') }}</h2>
        <x-admin.filter-bar :active="$this->hasActiveFilters()" :total="$items->total()">
            <x-admin.select wire:model.live="statusFilter" :options="collect(['pending', 'sent', 'delivered', 'read', 'failed'])->map(fn($s) => ['value' => $s, 'label' => $s])->all()" :searchable="false" placeholder="All statuses" class="w-40" />
            <x-admin.select wire:model.live="templateFilter" :options="$templates->map(fn($t) => ['value' => $t->id, 'label' => $t->key])->all()" placeholder="All templates" class="w-48" />
            <x-admin.date-range />
        </x-admin.filter-bar>
    </div>
    <div class="bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden">
        <table class="w-full text-sm">
            <thead class="bg-stone-800/60">
                <tr>
                    <th class="px-4 py-3 text-start">Phone</th>
                    <th class="px-4 py-3 text-start">Customer</th>
                    <th class="px-4 py-3 text-start">Template</th>
                    <th class="px-4 py-3 text-start">Status</th>
                    <th class="px-4 py-3 text-start">Date</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-800">
                @forelse ($items as $log)
                    <tr class="hover:bg-stone-800/40">
                        <td class="px-4 py-3 font-mono text-xs">{{ $log->phone }}</td>
                        <td class="px-4 py-3">{{ $log->customer?->name ?? '—' }}</td>
                        <td class="px-4 py-3 text-stone-400">{{ $log->template?->key ?? '—' }}</td>
                        <td class="px-4 py-3">
                            <span class="px-2 py-0.5 rounded-full text-xs {{ $log->status === 'failed' ? 'bg-red-500/20 text-red-400' : ($log->status === 'pending' ? 'bg-stone-800 text-stone-300' : 'bg-emerald-500/20 text-emerald-400') }}">{{ $log->status }}</span>
                        </td>
                        <td class="px-4 py-3 text-stone-400 text-xs">{{ $log->created_at->format('Y-m-d H:i') }}</td>
                    </tr>
                @empty
                    <tr><td colspan="5" class="px-4 py-8 text-center text-stone-500">{{ __('messages.admin.no_data') }}</td></tr>
                @endforelse
            </tbody>
        </table>
        <div class="p-3">{{ $items->links() }}</div>
    </div>
</div>
