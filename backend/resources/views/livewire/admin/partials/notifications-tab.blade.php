{{-- expects: $emailLogs, $waLogs, $canResend --}}
@php $badge = fn ($s) => match ($s) { 'sent' => 'bg-emerald-500/20 text-emerald-400', 'failed' => 'bg-red-500/20 text-red-400', default => 'bg-stone-700 text-stone-300' }; @endphp
<div class="space-y-5 text-sm">
    <div>
        <h4 class="font-bold text-stone-200 mb-2">{{ __('messages.admin.email') }}</h4>
        <div class="bg-stone-800/30 rounded-lg divide-y divide-stone-800">
            @forelse ($emailLogs as $l)
                <div class="p-3 flex items-center justify-between gap-3">
                    <div class="min-w-0">
                        <div class="font-mono text-xs">{{ $l->event }} <span class="text-stone-500">· {{ $l->locale }}</span></div>
                        <div class="text-xs text-stone-400 truncate">{{ $l->recipient }} · {{ $l->created_at->format('Y-m-d H:i') }}</div>
                        @if ($l->error)<div class="text-xs text-red-400 truncate">{{ $l->error }}</div>@endif
                    </div>
                    <div class="flex items-center gap-2 shrink-0">
                        <span class="px-2 py-0.5 rounded-full text-xs {{ $badge($l->status) }}">{{ $l->status }}</span>
                        @if ($canResend)
                            <button wire:click="resendNotification('email', {{ $l->id }})" class="text-yellow-500 text-xs">{{ __('messages.admin.resend') }}</button>
                        @endif
                    </div>
                </div>
            @empty
                <div class="p-3 text-stone-500 text-xs">{{ __('messages.admin.no_emails') }}</div>
            @endforelse
        </div>
    </div>
    <div>
        <h4 class="font-bold text-stone-200 mb-2">{{ __('messages.admin.whatsapp_label') }}</h4>
        <div class="bg-stone-800/30 rounded-lg divide-y divide-stone-800">
            @forelse ($waLogs as $l)
                <div class="p-3 flex items-center justify-between gap-3">
                    <div class="min-w-0">
                        <div class="font-mono text-xs">{{ $l->template_key ?? optional($l->template)->key }} <span class="text-stone-500">· {{ $l->locale }}</span></div>
                        <div class="text-xs text-stone-400 truncate">{{ $l->phone }} · {{ $l->created_at->format('Y-m-d H:i') }}</div>
                        @if (!empty($l->response['error']))<div class="text-xs text-red-400 truncate">{{ $l->response['error'] }}</div>@endif
                    </div>
                    <div class="flex items-center gap-2 shrink-0">
                        <span class="px-2 py-0.5 rounded-full text-xs {{ $badge($l->status) }}">{{ $l->status }}</span>
                        @if ($canResend)
                            <button wire:click="resendNotification('whatsapp', {{ $l->id }})" class="text-yellow-500 text-xs">{{ __('messages.admin.resend') }}</button>
                        @endif
                    </div>
                </div>
            @empty
                <div class="p-3 text-stone-500 text-xs">{{ __('messages.admin.no_whatsapp_messages') }}</div>
            @endforelse
        </div>
    </div>
</div>
