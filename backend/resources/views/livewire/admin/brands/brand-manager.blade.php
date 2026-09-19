<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.brands') }}</h2>
        <div class="flex gap-2 flex-wrap">
            <input type="search" wire:model.live.debounce.400ms="search" placeholder="{{ __('messages.admin.search') }}"
                class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
            @can('brands.create')
<button wire:click="openCreate"
                class="bg-yellow-500 hover:bg-yellow-400 text-stone-950 font-bold px-4 py-2 rounded-lg text-sm">
                + {{ __('messages.admin.add_new') }}
            </button>
@endcan
        </div>
    </div>

    <div class="bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden">
        <table class="w-full text-sm">
            <thead class="bg-stone-800/60 text-stone-300">
                <tr>
                    <th class="px-4 py-3 text-start">#</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.name') }}</th>
                    <th class="px-4 py-3 text-start">Slug</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.status') }}</th>
                    <th class="px-4 py-3 text-start">Daftra</th>
                    <th class="px-4 py-3 text-end">{{ __('messages.admin.actions') }}</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-800">
                @forelse ($brands as $b)
                    <tr class="hover:bg-stone-800/40">
                        <td class="px-4 py-3 text-stone-400">{{ $b->id }}</td>
                        <td class="px-4 py-3 font-bold text-stone-100">{{ $b->name }}</td>
                        <td class="px-4 py-3 text-stone-400">{{ $b->slug }}</td>
                        <td class="px-4 py-3">
                            <span
                                class="px-2 py-0.5 rounded-full text-xs {{ $b->is_active ? 'bg-emerald-500/20 text-emerald-400' : 'bg-stone-700 text-stone-300' }}">
                                {{ $b->is_active ? __('messages.admin.active') : __('messages.admin.inactive') }}
                            </span>
                        </td>
                        <td class="px-4 py-3">
                            @if ($b->daftra_id)
                                <span class="px-2 py-0.5 rounded-full text-xs bg-emerald-500/20 text-emerald-400 font-mono">#{{ $b->daftra_id }}</span>
                            @else
                                <span class="text-stone-600 text-xs">—</span>
                            @endif
                        </td>
                        <td class="px-4 py-3 text-end">
                            @can('brands.update')
<button wire:click="edit({{ $b->id }})"
                                class="text-yellow-500 hover:underline text-xs me-3">{{ __('messages.admin.edit') }}</button>
@endcan
                            @can('brands.delete')
<button wire:click="confirmDelete({{ $b->id }})"
                                class="text-red-400 hover:underline text-xs">{{ __('messages.admin.delete') }}</button>
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
        <div class="p-3">{{ $brands->links() }}</div>
    </div>

    @if ($showForm)
        <div class="fixed inset-0 bg-black/60 flex items-center justify-center z-40 p-4"
            wire:click.self="$set('showForm', false)">
            <div class="bg-stone-900 border border-stone-800 rounded-2xl w-full max-w-2xl p-6 space-y-4">
                <div class="flex justify-between items-center">
                    <h3 class="text-lg font-bold">
                        {{ $editingId ? __('messages.admin.edit') : __('messages.admin.add_new') }}</h3>
                    <button wire:click="$set('showForm', false)" class="text-stone-400 hover:text-stone-100">✕</button>
                </div>
                <div class="grid sm:grid-cols-2 gap-3">
                    <div>
                        <label class="text-xs text-stone-400">{{ __('messages.admin.name') }}
                            ({{ __('messages.admin.arabic') }})</label>
                        <input wire:model="form.translations.ar.name"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                        @error('form.translations.ar.name') <p class="text-red-400 text-xs mt-1">{{ $message }}</p>
                        @enderror
                    </div>
                    <div>
                        <label class="text-xs text-stone-400">{{ __('messages.admin.name') }}
                            ({{ __('messages.admin.english') }})</label>
                        <input wire:model="form.translations.en.name"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                        @error('form.translations.en.name') <p class="text-red-400 text-xs mt-1">{{ $message }}</p>
                        @enderror
                    </div>
                    <div>
                        <label class="text-xs text-stone-400">Slug</label>
                        <input wire:model="form.slug"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                    </div>
                    <div>
                        <label class="text-xs text-stone-400">Country</label>
                        <input wire:model="form.country"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                    </div>
                    <div>
                        <label class="text-xs text-stone-400">Sort order</label>
                        <input type="number" wire:model="form.sort_order"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                    </div>
                    <label class="flex items-center gap-2 mt-6">
                        <input type="checkbox" wire:model="form.is_active"
                            class="rounded bg-stone-800 border-stone-700 text-yellow-500">
                        <span class="text-sm">{{ __('messages.admin.active') }}</span>
                    </label>
                </div>
                <div class="flex justify-end gap-2 pt-2 border-t border-stone-800">
                    <button wire:click="$set('showForm', false)"
                        class="px-4 py-2 rounded-lg bg-stone-800 hover:bg-stone-700 text-sm">{{ __('messages.admin.cancel') }}</button>
                    @canany(['brands.create', 'brands.update'])
<button wire:click="save"
                        class="px-4 py-2 rounded-lg bg-yellow-500 hover:bg-yellow-400 text-stone-950 font-bold text-sm">{{ __('messages.admin.save') }}</button>
@endcanany
                </div>
            </div>
        </div>
    @endif
</div>