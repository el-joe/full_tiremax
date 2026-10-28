<div class="space-y-4" wire:poll.3s>
    <h2 class="text-xl font-bold">{{ __('messages.admin.wa_connection') }}</h2>

    @if ($flash)
        <div class="rounded-xl px-4 py-2 text-sm {{ $flashType === 'error' ? 'bg-red-500/20 text-red-400' : 'bg-emerald-500/20 text-emerald-400' }}">{{ $flash }}</div>
    @endif

    <div class="grid lg:grid-cols-2 gap-4">
        <div class="bg-stone-900 border border-stone-800 rounded-2xl p-5 space-y-4">
            <div class="flex items-center justify-between">
                <div class="font-bold">{{ __('messages.admin.wa_qr_session') }}</div>
                <span class="px-2 py-0.5 rounded-full text-xs {{ $gw['status'] === 'connected' ? 'bg-emerald-500/20 text-emerald-400' : ($gw['status'] === 'offline' ? 'bg-red-500/20 text-red-400' : 'bg-stone-800 text-stone-300') }}">
                    {{ __('messages.admin.wa_status_' . $gw['status']) }}
                </span>
            </div>

            @if ($gw['status'] === 'connected')
                <div class="text-sm space-y-1">
                    <div><span class="text-stone-400">{{ __('messages.admin.phone') }}:</span> <span dir="ltr" class="font-mono">+{{ $gw['number'] }}</span></div>
                    @if ($gw['name'])<div><span class="text-stone-400">{{ __('messages.admin.name') }}:</span> {{ $gw['name'] }}</div>@endif
                </div>
                @can('whatsapp.update')
                    <button wire:click="disconnect" wire:confirm="{{ __('messages.admin.wa_confirm_disconnect') }}" class="px-4 py-2 rounded-lg bg-red-500/20 text-red-400 text-sm">{{ __('messages.admin.wa_disconnect') }}</button>
                @endcan
            @elseif ($gw['status'] === 'qr' && $gw['qr'])
                <div class="bg-white rounded-xl p-3 w-fit mx-auto"><img src="{{ $gw['qr'] }}" alt="QR" width="280" height="280"></div>
                <p class="text-xs text-stone-400 text-center">{{ __('messages.admin.wa_scan_hint') }}</p>
            @elseif ($gw['status'] === 'offline')
                <p class="text-sm text-stone-400">{{ __('messages.admin.wa_gateway_offline') }}</p>
            @else
                <p class="text-sm text-stone-400">{{ $gw['status'] === 'connecting' ? __('messages.admin.wa_connecting') : __('messages.admin.wa_not_linked') }}</p>
                @can('whatsapp.update')
                    <button wire:click="connect" class="px-4 py-2 rounded-lg bg-yellow-500 text-stone-900 text-sm font-bold">{{ __('messages.admin.wa_generate_qr') }}</button>
                @endcan
            @endif

            @if ($gw['status'] === 'connected')
                @can('whatsapp.update')
                    <form wire:submit="sendTest" class="flex gap-2 items-start pt-3 border-t border-stone-800">
                        <div class="flex-1">
                            <input type="text" dir="ltr" wire:model="testPhone" placeholder="01012345678" class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                            @error('testPhone') <p class="text-xs text-red-400 mt-1">{{ $message }}</p> @enderror
                        </div>
                        <button class="px-4 py-2 rounded-lg bg-stone-700 text-sm">{{ __('messages.admin.wa_send_test') }}</button>
                    </form>
                @endcan
            @endif
        </div>

        <div class="bg-stone-900 border border-stone-800 rounded-2xl p-5 space-y-4">
            <div class="font-bold">{{ __('messages.admin.wa_usage') }}</div>
            <div class="grid grid-cols-3 gap-3 text-center">
                <div class="bg-stone-800 rounded-xl p-3"><div class="text-2xl font-bold">{{ $sentToday }}<span class="text-xs text-stone-500">/{{ $dailyLimit ?: '∞' }}</span></div><div class="text-xs text-stone-400">{{ __('messages.admin.wa_today') }}</div></div>
                <div class="bg-stone-800 rounded-xl p-3"><div class="text-2xl font-bold">{{ $sentHour }}<span class="text-xs text-stone-500">/{{ $hourlyLimit ?: '∞' }}</span></div><div class="text-xs text-stone-400">{{ __('messages.admin.wa_last_hour') }}</div></div>
                <div class="bg-stone-800 rounded-xl p-3"><div class="text-2xl font-bold">{{ $queued }}</div><div class="text-xs text-stone-400">{{ __('messages.admin.wa_queued') }}</div></div>
            </div>
        </div>
    </div>

    @can('whatsapp.update')
    <form wire:submit="saveSettings" class="bg-stone-900 border border-stone-800 rounded-2xl p-5 space-y-4">
        <div class="font-bold">{{ __('messages.admin.wa_sending_settings') }}</div>
        <div class="grid sm:grid-cols-2 lg:grid-cols-4 gap-3">
            @foreach ([['dailyLimit', 'wa_daily_limit'], ['hourlyLimit', 'wa_hourly_limit'], ['minGap', 'wa_min_gap'], ['maxGap', 'wa_max_gap']] as [$field, $label])
                <div>
                    <label class="text-xs text-stone-400">{{ __('messages.admin.' . $label) }}</label>
                    <input type="number" min="0" wire:model="{{ $field }}" class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                    @error($field) <p class="text-xs text-red-400 mt-1">{{ $message }}</p> @enderror
                </div>
            @endforeach
        </div>
        <p class="text-xs text-stone-500">{{ __('messages.admin.wa_limits_hint') }}</p>
        <button class="px-4 py-2 rounded-lg bg-yellow-500 text-stone-900 text-sm font-bold">{{ __('messages.admin.save') }}</button>
    </form>
    @endcan
</div>
