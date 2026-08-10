<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.daftra_logs') }}</h2>
        <div class="flex gap-2 flex-wrap">
            <x-admin.select wire:model.live="entityTypeFilter" :options="$entityTypes->map(fn($t) => ['value' => $t, 'label' => class_basename($t)])->all()" placeholder="All types" class="w-44" />
            <x-admin.select wire:model.live="statusFilter" :options="[['value' => 'success', 'label' => 'success'], ['value' => 'failed', 'label' => 'failed'], ['value' => 'pending', 'label' => 'pending']]" placeholder="All statuses" class="w-44" />
        </div>
    </div>
    <div class="bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden">
        <table class="w-full text-sm">
            <thead class="bg-stone-800/60">
                <tr>
                    <th class="px-4 py-3 text-start">Entity</th>
                    <th class="px-4 py-3 text-start">Status</th>
                    <th class="px-4 py-3 text-start">Daftra ID</th>
                    <th class="px-4 py-3 text-start">Error</th>
                    <th class="px-4 py-3 text-start">Synced At</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-800">
                @forelse ($items as $log)
                    <tr class="hover:bg-stone-800/40">
                        <td class="px-4 py-3">
                            <span class="font-bold">{{ class_basename($log->syncable_type ?? 'Order') }}</span>
                            <span class="text-xs text-stone-400">#{{ $log->syncable_id ?? $log->order_id }}</span>
                        </td>
                        <td class="px-4 py-3">
                            @php
                                $badge = match ($log->status) {
                                    'success' => 'bg-emerald-500/20 text-emerald-400',
                                    'failed' => 'bg-red-500/20 text-red-400',
                                    default => 'bg-stone-800 text-stone-300',
                                };
                            @endphp
                            <span class="px-2 py-0.5 rounded-full text-xs {{ $badge }}">{{ $log->status }}</span>
                        </td>
                        <td class="px-4 py-3 font-mono text-xs text-stone-400">
                            {{ $log->response['id'] ?? $log->response['Invoice']['id'] ?? '—' }}
                        </td>
                        <td class="px-4 py-3 text-xs text-red-400 max-w-xs truncate">
                            {{ $log->response['error'] ?? '—' }}
                        </td>
                        <td class="px-4 py-3 text-stone-400 text-xs">{{ $log->updated_at->format('Y-m-d H:i') }}</td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="5" class="px-4 py-8 text-center text-stone-500">{{ __('messages.admin.no_data') }}</td>
                    </tr>
                @endforelse
            </tbody>
        </table>
        <div class="p-3">{{ $items->links() }}</div>
    </div>
</div>
