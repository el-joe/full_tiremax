<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.payment_gateways') }}</h2>
    </div>
    <div class="bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden">
        <table class="w-full text-sm">
            <thead class="bg-stone-800/60">
                <tr>
                    <th class="px-4 py-3 text-start">Driver</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.name') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.status') }}</th>
                    <th class="px-4 py-3 text-end">{{ __('messages.admin.actions') }}</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-800">
                @forelse ($items as $gateway)
                    <tr class="hover:bg-stone-800/40" wire:key="gateway-{{ $gateway->id }}">
                        <td class="px-4 py-3 font-mono text-xs text-stone-400">{{ $gateway->name }}</td>
                        <td class="px-4 py-3">
                            <input type="text" wire:key="name-{{ $gateway->id }}"
                                x-data="{ value: @js($gateway->display_name) }" x-model="value"
                                x-on:keydown.enter="$wire.updateDisplayName({{ $gateway->id }}, value)"
                                class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                        </td>
                        <td class="px-4 py-3">
                            <button wire:click="toggleActive({{ $gateway->id }})"
                                class="px-2 py-0.5 rounded-full text-xs {{ $gateway->is_active ? 'bg-emerald-500/20 text-emerald-400' : 'bg-stone-700 text-stone-400' }}">
                                {{ $gateway->is_active ? __('messages.admin.active') : __('messages.admin.inactive') }}
                            </button>
                        </td>
                        <td class="px-4 py-3 text-end">
                            <button
                                x-data
                                x-on:click="$wire.updateDisplayName({{ $gateway->id }}, $el.closest('tr').querySelector('input').value)"
                                class="bg-yellow-500 text-stone-950 font-bold px-3 py-1.5 rounded-lg text-xs">
                                {{ __('messages.admin.save') }}
                            </button>
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="4" class="px-4 py-8 text-center text-stone-500">{{ __('messages.admin.no_data') }}</td>
                    </tr>
                @endforelse
            </tbody>
        </table>
    </div>
</div>
