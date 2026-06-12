<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.customers') }}</h2>
        <input type="search" wire:model.live.debounce.400ms="search" placeholder="{{ __('messages.admin.search') }}"
            class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
    </div>
    <div class="bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden">
        <table class="w-full text-sm">
            <thead class="bg-stone-800/60">
                <tr>
                    <th class="px-4 py-3 text-start">#</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.name') }}</th>
                    <th class="px-4 py-3 text-start">Phone</th>
                    <th class="px-4 py-3 text-start">Email</th>
                    <th class="px-4 py-3 text-start">Orders</th>
                    <th class="px-4 py-3 text-start">Status</th>
                    <th class="px-4 py-3 text-start">Daftra</th>
                    <th class="px-4 py-3 text-end">{{ __('messages.admin.actions') }}</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-800">
                @forelse ($items as $c)
                    <tr class="hover:bg-stone-800/40">
                        <td class="px-4 py-3 text-stone-400">{{ $c->id }}</td>
                        <td class="px-4 py-3 font-bold">{{ $c->name }}</td>
                        <td class="px-4 py-3">{{ $c->phone }}</td>
                        <td class="px-4 py-3 text-stone-400">{{ $c->email }}</td>
                        <td class="px-4 py-3">{{ $c->orders_count }}</td>
                        <td class="px-4 py-3"><button wire:click="toggleActive({{ $c->id }})"
                                class="px-2 py-0.5 rounded-full text-xs {{ $c->is_active ? 'bg-emerald-500/20 text-emerald-400' : 'bg-stone-700' }}">{{ $c->is_active ? 'Active' : 'Inactive' }}</button>
                        </td>
                        <td class="px-4 py-3">
                            @if ($c->daftra_id)
                                <span class="px-2 py-0.5 rounded-full text-xs bg-emerald-500/20 text-emerald-400 font-mono">#{{ $c->daftra_id }}</span>
                            @else
                                <span class="text-stone-600 text-xs">—</span>
                            @endif
                        </td>
                        <td class="px-4 py-3 text-end"><button wire:click="confirmDelete({{ $c->id }})"
                                class="text-red-400 text-xs">{{ __('messages.admin.delete') }}</button></td>
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