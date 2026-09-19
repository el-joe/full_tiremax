<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.services') }}</h2>
        <div class="flex gap-2"><input type="search" wire:model.live.debounce.400ms="search"
                placeholder="{{ __('messages.admin.search') }}"
                class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">@can('services.create')
<button
                wire:click="openCreate" class="bg-yellow-500 text-stone-950 font-bold px-4 py-2 rounded-lg text-sm">+
                {{ __('messages.admin.add_new') }}</button>
@endcan</div>
    </div>
    <div class="bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden">
        <table class="w-full text-sm">
            <thead class="bg-stone-800/60">
                <tr>
                    <th class="px-4 py-3 text-start">#</th>
                    <th class="px-4 py-3 text-start">Image</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.name') }}</th>
                    <th class="px-4 py-3 text-start">Duration</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.price') }}</th>
                    <th class="px-4 py-3 text-end">{{ __('messages.admin.actions') }}</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-800">
                @forelse ($items as $s)
                    <tr class="hover:bg-stone-800/40">
                        <td class="px-4 py-3 text-stone-400">{{ $s->id }}</td>
                        <td class="px-4 py-3">
                            @if ($s->image)
                                <img src="{{ asset('storage/' . $s->image) }}" alt="{{ $s->name }}"
                                    class="w-10 h-10 rounded-lg object-cover">
                            @else
                                <div class="w-10 h-10 rounded-lg bg-stone-800 flex items-center justify-center text-stone-600">
                                    <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M4 16l4-4 4 4 4-6 4 6" />
                                    </svg>
                                </div>
                            @endif
                        </td>
                        <td class="px-4 py-3 font-bold">{{ $s->name }}</td>
                        <td class="px-4 py-3">{{ $s->duration_minutes }} min</td>
                        <td class="px-4 py-3">{{ number_format($s->price) }} IQD</td>
                        <td class="px-4 py-3 text-end">
                            @can('services.update')
<button wire:click="edit({{ $s->id }})"
                                class="text-yellow-500 text-xs me-3">{{ __('messages.admin.edit') }}</button>
@endcan
                            @can('services.delete')
<button wire:click="confirmDelete({{ $s->id }})"
                                class="text-red-400 text-xs">{{ __('messages.admin.delete') }}</button>
@endcan
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="6" class="px-4 py-8 text-center text-stone-500">{{ __('messages.admin.no_data') }}</td>
                    </tr>
                @endforelse
            </tbody>
        </table>
        <div class="p-3">{{ $items->links() }}</div>
    </div>
    @if ($showForm)
        <div class="fixed inset-0 bg-black/60 flex items-center justify-center z-40 p-4"
            wire:click.self="$set('showForm', false)">
            <div class="bg-stone-900 border border-stone-800 rounded-2xl w-full max-w-2xl p-6 space-y-4">
                <h3 class="text-lg font-bold">{{ $editingId ? __('messages.admin.edit') : __('messages.admin.add_new') }}
                </h3>
                <div class="grid sm:grid-cols-2 gap-3">
                    <div><label class="text-xs text-stone-400">Name (AR)</label><input
                            wire:model="form.translations.ar.name"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">Name (EN)</label><input
                            wire:model="form.translations.en.name"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">Description (AR)</label><textarea
                            wire:model="form.translations.ar.description"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"
                            rows="2"></textarea></div>
                    <div><label class="text-xs text-stone-400">Description (EN)</label><textarea
                            wire:model="form.translations.en.description"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"
                            rows="2"></textarea></div>

                    {{-- Image upload --}}
                    <div class="sm:col-span-2">
                        <label class="text-xs text-stone-400">Image</label>
                        <div class="mt-1 flex items-start gap-4">
                            {{-- Preview --}}
                            @if ($imageFile)
                                <img src="{{ $imageFile->temporaryUrl() }}"
                                    class="w-20 h-20 rounded-lg object-cover border border-stone-700">
                            @elseif ($existingImage)
                                <div class="relative">
                                    <img src="{{ asset('storage/' . $existingImage) }}"
                                        class="w-20 h-20 rounded-lg object-cover border border-stone-700">
                                    @can('services.update')
<button type="button" wire:click="removeImage"
                                        class="absolute -top-2 -right-2 bg-red-500 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs leading-none">×</button>
@endcan
                                </div>
                            @else
                                <div
                                    class="w-20 h-20 rounded-lg bg-stone-800 border border-dashed border-stone-600 flex items-center justify-center text-stone-600">
                                    <svg class="w-8 h-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                            d="M4 16l4-4 4 4 4-6 4 6" />
                                    </svg>
                                </div>
                            @endif
                            <div class="flex-1">
                                <input type="file" wire:model="imageFile" accept="image/*"
                                    class="w-full text-xs text-stone-400 file:mr-3 file:py-1.5 file:px-3 file:rounded file:border-0 file:bg-stone-700 file:text-stone-200 file:text-xs hover:file:bg-stone-600 cursor-pointer">
                                <p class="text-xs text-stone-500 mt-1">JPEG, PNG, WebP — max 2 MB</p>
                                @error('imageFile') <p class="text-red-400 text-xs mt-1">{{ $message }}</p> @enderror
                            </div>
                        </div>
                    </div>

                    <div><label class="text-xs text-stone-400">Duration (minutes)</label><input type="number"
                            wire:model="form.duration_minutes"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">Price</label><input type="number" wire:model="form.price"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <label class="flex items-center gap-2 mt-6"><input type="checkbox" wire:model="form.is_active"
                            class="rounded bg-stone-800 text-yellow-500"> Active</label>
                </div>
                <div class="flex justify-end gap-2 pt-2 border-t border-stone-800">
                    <button wire:click="$set('showForm', false)"
                        class="px-4 py-2 rounded-lg bg-stone-800 text-sm">{{ __('messages.admin.cancel') }}</button>
                    @canany(['services.create', 'services.update'])
<button wire:click="save"
                        class="px-4 py-2 rounded-lg bg-yellow-500 text-stone-950 font-bold text-sm">{{ __('messages.admin.save') }}</button>
@endcanany
                </div>
            </div>
        </div>
    @endif
</div>