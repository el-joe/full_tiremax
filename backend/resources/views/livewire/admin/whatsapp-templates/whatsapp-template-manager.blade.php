<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.whatsapp') }}</h2>
    </div>
    <div class="space-y-4">
        @forelse ($templates as $template)
            <div class="bg-stone-900 border border-stone-800 rounded-2xl p-5 space-y-3">
                <div class="flex items-center justify-between gap-3 flex-wrap">
                    <div>
                        <span class="text-xs uppercase tracking-wide text-stone-500">{{ __('messages.admin.name') }}</span>
                        <div class="font-bold">{{ $template->key }}</div>
                        @if ($template->trigger_after_days)
                            <div class="text-xs text-stone-500">+{{ $template->trigger_after_days }} {{ __('messages.admin.days_unit') }}</div>
                        @endif
                    </div>
                    <label class="flex items-center gap-2">
                        <input type="checkbox" wire:model="form.{{ $template->id }}.is_active"
                            class="rounded bg-stone-800 border-stone-700 text-yellow-500">
                        {{ __('messages.admin.active') }}
                    </label>
                </div>
                <div class="grid sm:grid-cols-2 gap-3">
                    <div>
                        <label class="text-xs text-stone-400">{{ __('messages.admin.subject_ar') }}</label>
                        <input type="text" wire:model="form.{{ $template->id }}.subject_ar"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                    </div>
                    <div>
                        <label class="text-xs text-stone-400">{{ __('messages.admin.subject_en') }}</label>
                        <input type="text" wire:model="form.{{ $template->id }}.subject_en"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                    </div>
                    <div>
                        <label class="text-xs text-stone-400">{{ __('messages.admin.body_ar') }}</label>
                        <textarea wire:model="form.{{ $template->id }}.body_ar" rows="4"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></textarea>
                    </div>
                    <div>
                        <label class="text-xs text-stone-400">{{ __('messages.admin.body_en') }}</label>
                        <textarea wire:model="form.{{ $template->id }}.body_en" rows="4"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></textarea>
                    </div>
                </div>
                <div class="flex justify-end pt-2 border-t border-stone-800">
                    @can('whatsapp.update')
<button wire:click="save({{ $template->id }})"
                        class="bg-yellow-500 text-stone-950 font-bold px-4 py-2 rounded-lg text-xs">
                        {{ __('messages.admin.save') }}
                    </button>
@endcan
                </div>
            </div>
        @empty
            <div class="bg-stone-900 border border-stone-800 rounded-2xl p-8 text-center text-stone-500">
                {{ __('messages.admin.no_data') }}
            </div>
        @endforelse
    </div>
</div>
