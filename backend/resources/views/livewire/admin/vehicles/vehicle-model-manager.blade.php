<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.vehicle_models') }}</h2>
        <div class="flex gap-2 flex-wrap items-center">
            <x-admin.filter-bar :active="$this->hasActiveFilters()" :total="$items->total()">
                <x-admin.select wire:model.live="makeId" :options="$makes->map(fn($x) => ['value' => $x->id, 'label' => $x->name])->all()" :searchable="true" placeholder="{{ __('messages.admin.all_makes') }}" class="w-44" />
                <x-admin.select wire:model.live="activeFilter" :options="[['value' => '1', 'label' => __('messages.admin.active')], ['value' => '0', 'label' => __('messages.admin.inactive')]]" :searchable="false" placeholder="{{ __('messages.admin.all') }}" class="w-36" />
            </x-admin.filter-bar>
            @can('vehicles.create')
<button wire:click="openCreate"
                class="bg-yellow-500 text-stone-950 font-bold px-4 py-2 rounded-lg text-sm">+
                {{ __('messages.admin.add_new') }}</button>
@endcan
        </div>
    </div>
    <div class="bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden">
        <table class="w-full text-sm">
            <thead class="bg-stone-800/60">
                <tr>
                    <th class="px-4 py-3 text-start">#</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.make') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.name') }}</th>
                    <th class="px-4 py-3 text-end">{{ __('messages.admin.actions') }}</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-800">
                @forelse ($items as $m)
                    <tr class="hover:bg-stone-800/40">
                        <td class="px-4 py-3 text-stone-400">{{ $m->id }}</td>
                        <td class="px-4 py-3">{{ optional($m->make)->name }}</td>
                        <td class="px-4 py-3 font-bold">{{ $m->name }}</td>
                        <td class="px-4 py-3 text-end">
                            @can('vehicles.update')
<button wire:click="edit({{ $m->id }})"
                                class="text-yellow-500 text-xs me-3">{{ __('messages.admin.edit') }}</button>
@endcan
                            @can('vehicles.delete')
<button wire:click="confirmDelete({{ $m->id }})"
                                class="text-red-400 text-xs">{{ __('messages.admin.delete') }}</button>
@endcan
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="4" class="px-4 py-8 text-center text-stone-500">{{ __('messages.admin.no_data') }}</td>
                    </tr>
                @endforelse
            </tbody>
        </table>
        <div class="p-3">{{ $items->links() }}</div>
    </div>
    @if ($showForm)
        <div class="fixed inset-0 bg-black/60 flex items-center justify-center z-40 p-4"
            wire:click.self="$set('showForm', false)">
            <div class="bg-stone-900 border border-stone-800 rounded-2xl w-full max-w-xl p-6 space-y-4">
                <h3 class="text-lg font-bold">{{ $editingId ? __('messages.admin.edit') : __('messages.admin.add_new') }}
                </h3>
                <div class="grid sm:grid-cols-2 gap-3">
                    <div class="sm:col-span-2"><label class="text-xs text-stone-400">{{ __('messages.admin.make') }}</label>
                        <x-admin.select wire:model="form.vehicle_make_id" :options="$makes->map(fn($mk) => ['value' => $mk->id, 'label' => $mk->name])->all()" placeholder="—" />
                        @error('form.vehicle_make_id') <p class="text-red-400 text-xs">{{ $message }}</p> @enderror
                    </div>
                    <div><label class="text-xs text-stone-400">{{ __('messages.admin.name_ar') }}</label><input
                            wire:model="form.translations.ar.name"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">{{ __('messages.admin.name_en') }}</label><input
                            wire:model="form.translations.en.name"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">{{ __('messages.admin.slug') }}</label><input wire:model="form.slug"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">{{ __('messages.admin.sort_order') }}</label><input type="number"
                            wire:model="form.sort_order"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <label class="flex items-center gap-2 mt-6"><input type="checkbox" wire:model="form.is_active"
                            class="rounded bg-stone-800 text-yellow-500"> {{ __('messages.admin.active') }}</label>
                </div>
                <div class="flex justify-end gap-2 pt-2 border-t border-stone-800">
                    <button wire:click="$set('showForm', false)"
                        class="px-4 py-2 rounded-lg bg-stone-800 text-sm">{{ __('messages.admin.cancel') }}</button>
                    @canany(['vehicles.create', 'vehicles.update'])
<button wire:click="save"
                        class="px-4 py-2 rounded-lg bg-yellow-500 text-stone-950 font-bold text-sm">{{ __('messages.admin.save') }}</button>
@endcanany
                </div>
            </div>
        </div>
    @endif
</div>