<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.whatsapp') }}</h2>
    </div>
    <div class="space-y-4">
        @forelse ($templates as $template)
            <div class="bg-stone-900 border border-stone-800 rounded-2xl p-5 space-y-3">
                <div class="flex items-center justify-between gap-3 flex-wrap">
                    <div>
                        @php $known = \Illuminate\Support\Facades\Lang::has('messages.admin.whatsapp_templates.' . $template->key); @endphp
                        <div class="font-bold">{{ $known ? __('messages.admin.whatsapp_templates.' . $template->key . '.name') : $template->key }}</div>
                        <div class="text-xs font-mono text-stone-500">{{ $template->key }}</div>
                        @if ($known)
                            <div class="text-xs text-stone-400 mt-1">{{ __('messages.admin.whatsapp_templates.' . $template->key . '.desc') }}</div>
                        @endif
                        <span class="inline-block mt-1 px-2 py-0.5 rounded-full text-[10px] {{ $template->trigger_after_days ? 'bg-blue-500/20 text-blue-400' : 'bg-stone-700/50 text-stone-400' }}">
                            {{ $template->trigger_after_days ? __('messages.admin.automated_followup') : __('messages.admin.event_based') }}
                        </span>
                    </div>
                    <label class="flex items-center gap-2">
                        <input type="checkbox" wire:model="form.{{ $template->id }}.is_active"
                            class="rounded bg-stone-800 border-stone-700 text-yellow-500">
                        {{ __('messages.admin.active') }}
                    </label>
                </div>
                @if ($template->trigger_after_days !== null)
                    <div class="max-w-xs">
                        <label class="text-xs text-stone-400">{{ __('messages.admin.trigger_after_days') }}</label>
                        <input type="number" min="1" wire:model="form.{{ $template->id }}.trigger_after_days"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                        @error("form.{$template->id}.trigger_after_days") <p class="text-xs text-red-400 mt-1">{{ $message }}</p> @enderror
                    </div>
                @endif
                @if (!empty($template->variables))
                    <div class="flex flex-wrap items-center gap-1.5 text-xs">
                        <span class="text-stone-500">{{ __('messages.admin.available_variables') }}:</span>
                        @foreach ($template->variables as $var)
                            <code class="px-1.5 py-0.5 rounded bg-stone-800 text-yellow-500" dir="ltr">&#123;&#123;{{ $var }}&#125;&#125;</code>
                        @endforeach
                    </div>
                @endif
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
