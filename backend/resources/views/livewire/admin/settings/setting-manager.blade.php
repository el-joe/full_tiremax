<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.settings') }}</h2>
    </div>
    <div class="bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden">
        <table class="w-full text-sm">
            <thead class="bg-stone-800/60">
                <tr>
                    <th class="px-4 py-3 text-start">Key</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.name') }} (AR)</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.name') }} (EN)</th>
                    <th class="px-4 py-3 text-end">{{ __('messages.admin.actions') }}</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-800">
                @forelse ($settings as $setting)
                    <tr class="hover:bg-stone-800/40">
                        <td class="px-4 py-3 font-bold">
                            {{ $setting->key }}
                            <div class="text-xs text-stone-500">{{ $setting->group }}</div>
                        </td>
                        @if ($setting->is_translatable)
                            <td class="px-4 py-3">
                                <input wire:model="form.{{ $setting->id }}.ar"
                                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                            </td>
                            <td class="px-4 py-3">
                                <input wire:model="form.{{ $setting->id }}.en"
                                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                            </td>
                        @else
                            <td class="px-4 py-3" colspan="2">
                                @if ($setting->cast === 'bool')
                                    <label class="flex items-center gap-2">
                                        <input type="checkbox" wire:model="form.{{ $setting->id }}.value"
                                            class="rounded bg-stone-800 border-stone-700 text-yellow-500">
                                        {{ __('messages.admin.active') }}
                                    </label>
                                @else
                                    <input wire:model="form.{{ $setting->id }}.value"
                                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                                @endif
                            </td>
                        @endif
                        <td class="px-4 py-3 text-end">
                            <button wire:click="save({{ $setting->id }})"
                                class="bg-yellow-500 text-stone-950 font-bold px-4 py-2 rounded-lg text-xs">
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
