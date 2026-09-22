<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.customers') }}</h2>
        <div class="flex gap-2 flex-wrap items-center">
            <x-admin.filter-bar :active="$this->hasActiveFilters()" :total="$items->total()">
                <x-admin.select wire:model.live="statusFilter" :options="[['value' => 'active', 'label' => __('messages.admin.active')], ['value' => 'inactive', 'label' => __('messages.admin.inactive')], ['value' => 'banned', 'label' => __('messages.admin.banned')]]" :searchable="false" placeholder="{{ __('messages.admin.all_statuses') }}" class="w-36" />
                <x-admin.select wire:model.live="hasOrders" :options="[['value' => 'yes', 'label' => __('messages.admin.has_orders')], ['value' => 'no', 'label' => __('messages.admin.no_orders')]]" :searchable="false" placeholder="{{ __('messages.admin.orders') }}" class="w-36" />
                <x-admin.select wire:model.live="localeFilter" :options="[['value' => 'ar', 'label' => __('messages.admin.arabic')], ['value' => 'en', 'label' => __('messages.admin.english')]]" :searchable="false" placeholder="{{ __('messages.admin.locale') }}" class="w-28" />
                <x-admin.date-range from="registeredFrom" to="registeredTo" />
            </x-admin.filter-bar>
            
        </div>
    </div>
    <div class="bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden">
        <table class="w-full text-sm">
            <thead class="bg-stone-800/60">
                <tr>
                    <th class="px-4 py-3 text-start">#</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.name') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.phone') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.email') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.orders') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.status') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.daftra') }}</th>
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
                        <td class="px-4 py-3">@can('customers.update')
<button wire:click="toggleActive({{ $c->id }})"
                                class="px-2 py-0.5 rounded-full text-xs {{ $c->is_active ? 'bg-emerald-500/20 text-emerald-400' : 'bg-stone-700' }}">{{ $c->is_active ? __('messages.admin.active') : __('messages.admin.inactive') }}</button>
@endcan
                        </td>
                        <td class="px-4 py-3">
                            @if ($c->daftra_id)
                                <span class="px-2 py-0.5 rounded-full text-xs bg-emerald-500/20 text-emerald-400 font-mono">#{{ $c->daftra_id }}</span>
                            @else
                                <span class="text-stone-600 text-xs">—</span>
                            @endif
                        </td>
                        <td class="px-4 py-3 text-end">
                            <button wire:click="view({{ $c->id }})" class="text-yellow-500 text-xs me-3">{{ __('messages.admin.view') }}</button>
                            @can('customers.update')
<button wire:click="linkGuestOrders({{ $c->id }})" class="text-sky-400 text-xs me-3">{{ __('messages.admin.link_guest_orders') }}</button>
@endcan
                            @can('customers.delete')
<button wire:click="confirmDelete({{ $c->id }})"
                                class="text-red-400 text-xs">{{ __('messages.admin.delete') }}</button>
@endcan
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
                        <h3 class="text-lg font-bold text-yellow-500">{{ $viewing->name }}</h3>
                        <p class="text-xs text-stone-400">{{ __('messages.admin.joined') }} {{ $viewing->created_at->format('Y-m-d') }}</p>
                    </div>
                    <button wire:click="close" class="text-stone-400 hover:text-stone-100">✕</button>
                </div>

                <div class="grid sm:grid-cols-2 gap-4 text-sm">
                    <div class="bg-stone-800/50 rounded-lg p-3">
                        <div class="text-xs text-stone-400">{{ __('messages.admin.contact') }}</div>
                        <div class="font-bold">{{ $viewing->phone }}</div>
                        <div class="text-xs text-stone-400">{{ $viewing->email }}</div>
                    </div>
                    <div class="bg-stone-800/50 rounded-lg p-3">
                        <div class="text-xs text-stone-400">{{ __('messages.admin.locale_address') }}</div>
                        <div>{{ strtoupper($viewing->locale) }}</div>
                        <div class="text-xs text-stone-400">{{ $viewing->address }}</div>
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-3 text-sm">
                    <div class="bg-stone-800/50 rounded-lg p-2">
                        <div class="text-xs text-stone-400">{{ __('messages.admin.total_orders') }}</div>
                        <div class="font-bold">{{ $viewing->total_orders }}</div>
                    </div>
                    <div class="bg-yellow-500/20 rounded-lg p-2">
                        <div class="text-xs text-yellow-500">{{ __('messages.admin.total_spent') }}</div>
                        <div class="font-bold">{{ number_format($viewing->total_spent ?? 0) }} IQD</div>
                    </div>
                </div>

                <div>
                    <h4 class="font-bold mb-2 text-stone-200">{{ __('messages.admin.recent_orders') }}</h4>
                    <div class="bg-stone-800/30 rounded-lg divide-y divide-stone-800">
                        @forelse ($viewing->orders as $o)
                            <a href="{{ route('admin.orders.index', ['q' => $o->reference]) }}"
                                class="flex justify-between p-3 text-sm hover:bg-stone-800/60">
                                <div>
                                    <div class="font-mono text-yellow-500">{{ $o->reference }}</div>
                                    <div class="text-xs text-stone-400">{{ $o->created_at->format('Y-m-d H:i') }}</div>
                                </div>
                                <div class="text-end">
                                    <div class="font-bold">{{ number_format($o->total) }} IQD</div>
                                    <span class="px-2 py-0.5 bg-stone-800 rounded-full text-xs">{{ $o->status }}</span>
                                </div>
                            </a>
                        @empty
                            <div class="p-3 text-center text-stone-500 text-sm">{{ __('messages.admin.no_orders') }}</div>
                        @endforelse
                    </div>
                </div>

                <div>
                    <h4 class="font-bold mb-2 text-stone-200">{{ __('messages.admin.recent_bookings') }}</h4>
                    <div class="bg-stone-800/30 rounded-lg divide-y divide-stone-800">
                        @forelse ($viewing->bookings as $b)
                            <div class="flex justify-between p-3 text-sm">
                                <div>
                                    <div class="font-mono text-yellow-500">{{ $b->reference }}</div>
                                    <div class="text-xs text-stone-400">{{ optional($b->service)->name }}</div>
                                </div>
                                <div class="text-end">
                                    <div class="text-xs text-stone-400">{{ optional($b->scheduled_at)->format('Y-m-d H:i') }}</div>
                                    <span class="px-2 py-0.5 bg-stone-800 rounded-full text-xs">{{ $b->status }}</span>
                                </div>
                            </div>
                        @empty
                            <div class="p-3 text-center text-stone-500 text-sm">{{ __('messages.admin.no_bookings') }}</div>
                        @endforelse
                    </div>
                </div>

                <div>
                    <h4 class="font-bold mb-2 text-stone-200">{{ __('messages.admin.audit_logs') }}</h4>
                    <div class="bg-stone-800/30 rounded-lg divide-y divide-stone-800">
                        @forelse ($auditLogs as $log)
                            <div class="flex justify-between p-3 text-sm">
                                <div>
                                    <div class="font-mono text-yellow-500">{{ $log->action }}</div>
                                    <div class="text-xs text-stone-400">{{ optional($log->admin)->name ?? __('messages.admin.system') }}</div>
                                </div>
                                <div class="text-end text-xs text-stone-400">{{ $log->created_at->format('Y-m-d H:i') }}</div>
                            </div>
                        @empty
                            <div class="p-3 text-center text-stone-500 text-sm">{{ __('messages.admin.no_audit_entries') }}</div>
                        @endforelse
                    </div>
                </div>

                <div class="border-t border-stone-800 pt-3 flex items-center gap-3">
                    @can('customers.update')
<button wire:click="toggleActive({{ $viewing->id }})"
                        class="px-3 py-1 rounded-full text-xs {{ $viewing->is_active ? 'bg-emerald-500/20 text-emerald-400' : 'bg-stone-700' }}">
                        {{ $viewing->is_active ? __('messages.admin.active') : __('messages.admin.inactive') }}
                    </button>
@endcan
                    @can('customers.ban')
<button wire:click="toggleBanned({{ $viewing->id }})"
                        class="px-3 py-1 rounded-full text-xs {{ $viewing->is_banned ? 'bg-red-500/20 text-red-400' : 'bg-stone-700' }}">
                        {{ $viewing->is_banned ? __('messages.admin.unban') : __('messages.admin.ban') }}
                    </button>
@endcan
                </div>
            </div>
        </div>
    @endif
</div>