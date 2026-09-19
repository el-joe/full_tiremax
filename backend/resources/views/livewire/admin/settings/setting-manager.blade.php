<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.settings') }}</h2>
    </div>

    @forelse ($groups as $groupKey => $groupSettings)
        <div class="bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden">
            <div class="px-5 py-3 bg-stone-800/60 border-b border-stone-800">
                <h3 class="font-bold">{{ __('messages.admin.setting_groups.' . $groupKey) }}</h3>
            </div>
            <div class="divide-y divide-stone-800">
                @foreach ($groupSettings as $setting)
                    <div class="px-5 py-4 flex flex-col lg:flex-row lg:items-start gap-3">
                        <div class="lg:w-56 shrink-0 font-bold text-sm pt-2">
                            {{ __('messages.admin.setting_keys.' . $setting->key) }}
                        </div>

                        <div class="flex-1 min-w-0">
                            @if ($setting->is_translatable)
                                <div class="grid sm:grid-cols-2 gap-3">
                                    <div>
                                        <label class="text-xs text-stone-500">{{ __('messages.admin.arabic') }}</label>
                                        <input wire:model="form.{{ $setting->id }}.ar"
                                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm mt-1">
                                    </div>
                                    <div>
                                        <label class="text-xs text-stone-500">{{ __('messages.admin.english') }}</label>
                                        <input wire:model="form.{{ $setting->id }}.en"
                                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm mt-1">
                                    </div>
                                </div>
                            @elseif ($setting->cast === 'bool')
                                <label class="flex items-center gap-2 pt-2">
                                    <input type="checkbox" wire:model="form.{{ $setting->id }}.value"
                                        class="rounded bg-stone-800 border-stone-700 text-yellow-500">
                                    {{ __('messages.admin.active') }}
                                </label>
                            @elseif ($setting->cast === 'image')
                                <div class="flex items-start gap-4">
                                    @if (!empty($imageFiles[$setting->id]))
                                        <img src="{{ $imageFiles[$setting->id]->temporaryUrl() }}"
                                            class="w-16 h-16 rounded-lg object-cover border border-stone-700">
                                    @elseif (!empty($form[$setting->id]['value']))
                                        <div class="relative">
                                            <img src="{{ asset('storage/' . $form[$setting->id]['value']) }}"
                                                class="w-16 h-16 rounded-lg object-cover border border-stone-700">
                                            @can('settings.update')
<button type="button" wire:click="removeImage({{ $setting->id }})"
                                                class="absolute -top-2 -right-2 bg-red-500 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs leading-none">×</button>
@endcan
                                        </div>
                                    @else
                                        <div
                                            class="w-16 h-16 rounded-lg bg-stone-800 border border-dashed border-stone-600 flex items-center justify-center text-stone-600">
                                            <svg class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                    d="M4 16l4-4 4 4 4-6 4 6" />
                                            </svg>
                                        </div>
                                    @endif
                                    <div class="flex-1">
                                        <input type="file" wire:model="imageFiles.{{ $setting->id }}" accept="image/*"
                                            class="w-full text-xs text-stone-400 file:mr-3 file:py-1.5 file:px-3 file:rounded file:border-0 file:bg-stone-700 file:text-stone-200 file:text-xs hover:file:bg-stone-600 cursor-pointer">
                                        <p class="text-xs text-stone-500 mt-1">JPEG, PNG, WebP — max 2 MB</p>
                                        @error("imageFiles.{$setting->id}") <p class="text-red-400 text-xs mt-1">{{ $message }}</p> @enderror
                                    </div>
                                </div>
                            @else
                                <input wire:model="form.{{ $setting->id }}.value"
                                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                            @endif
                        </div>

                        <div class="lg:pt-1">
                            @can('settings.update')
<button wire:click="save({{ $setting->id }})"
                                class="bg-yellow-500 text-stone-950 font-bold px-4 py-2 rounded-lg text-xs whitespace-nowrap">
                                {{ __('messages.admin.save') }}
                            </button>
@endcan
                        </div>
                    </div>
                @endforeach
            </div>
        </div>
    @empty
        <div class="bg-stone-900 border border-stone-800 rounded-2xl px-4 py-8 text-center text-stone-500">
            {{ __('messages.admin.no_data') }}
        </div>
    @endforelse
</div>
