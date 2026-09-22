<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.branches') }}</h2>
        <div class="flex gap-2 flex-wrap items-center">
            <x-admin.filter-bar :active="$this->hasActiveFilters()" :total="$items->total()">
                <x-admin.select wire:model.live="activeFilter" :options="[['value' => '1', 'label' => __('messages.admin.active')], ['value' => '0', 'label' => __('messages.admin.inactive')]]" :searchable="false" placeholder="{{ __('messages.admin.all') }}" class="w-36" />
                <x-admin.select wire:model.live="mainFilter" :options="[['value' => '1', 'label' => __('messages.admin.yes')], ['value' => '0', 'label' => __('messages.admin.no')]]" :searchable="false" placeholder="{{ __('messages.admin.is_main') }}?" class="w-36" />
            </x-admin.filter-bar>
            @can('branches.create')
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
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.name') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.code') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.phone') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.status') }}</th>
                    <th class="px-4 py-3 text-end">{{ __('messages.admin.actions') }}</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-800">
                @forelse ($items as $b)
                    <tr class="hover:bg-stone-800/40">
                        <td class="px-4 py-3 text-stone-400">{{ $b->id }}</td>
                        <td class="px-4 py-3 font-bold">{{ $b->name }}</td>
                        <td class="px-4 py-3 text-stone-400">{{ $b->code }}</td>
                        <td class="px-4 py-3">{{ $b->phone }}</td>
                        <td class="px-4 py-3"><span
                                class="px-2 py-0.5 rounded-full text-xs {{ $b->is_active ? 'bg-emerald-500/20 text-emerald-400' : 'bg-stone-700' }}">{{ $b->is_active ? __('messages.admin.active') : __('messages.admin.inactive') }}</span>
                        </td>
                        <td class="px-4 py-3 text-end">
                            @can('branches.update')
<button wire:click="edit({{ $b->id }})"
                                class="text-yellow-500 text-xs me-3">{{ __('messages.admin.edit') }}</button>
@endcan
                            @can('branches.delete')
<button wire:click="confirmDelete({{ $b->id }})"
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
            <div class="bg-stone-900 border border-stone-800 rounded-2xl w-full max-w-3xl p-6 space-y-4">
                <h3 class="text-lg font-bold">{{ $editingId ? __('messages.admin.edit') : __('messages.admin.add_new') }}
                </h3>
                <div class="grid sm:grid-cols-2 gap-3">
                    <div><label class="text-xs text-stone-400">{{ __('messages.admin.name_ar') }}</label><input
                            wire:model="form.translations.ar.name"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">{{ __('messages.admin.name_en') }}</label><input
                            wire:model="form.translations.en.name"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">{{ __('messages.admin.address_ar') }}</label><input
                            wire:model="form.translations.ar.address"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">{{ __('messages.admin.address_en') }}</label><input
                            wire:model="form.translations.en.address"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">{{ __('messages.admin.code') }}</label><input wire:model="form.code"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">{{ __('messages.admin.phone') }}</label><input wire:model="form.phone"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">{{ __('messages.admin.email') }}</label><input wire:model="form.email"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">{{ __('messages.admin.default_capacity') }}</label><input type="number"
                            wire:model="form.default_capacity"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">{{ __('messages.admin.latitude') }}</label><input wire:model="form.latitude"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">{{ __('messages.admin.longitude') }}</label><input wire:model="form.longitude"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div class="flex flex-col gap-1 mt-2 col-span-2">
                        <label class="flex items-center gap-2"><input type="checkbox" wire:model="form.is_main"
                                class="rounded bg-stone-800 text-yellow-500"> {{ __('messages.admin.is_main') }}</label>
                        <label class="flex items-center gap-2"><input type="checkbox" wire:model="form.is_active"
                                class="rounded bg-stone-800 text-yellow-500"> {{ __('messages.admin.active') }}</label>
                        <label class="flex items-center gap-2"><input type="checkbox"
                                wire:model="form.auto_confirm_bookings" class="rounded bg-stone-800 text-yellow-500">
                            {{ __('messages.admin.auto_confirm_bookings') }}</label>
                    </div>
                </div>
                <div class="flex justify-end gap-2 pt-2 border-t border-stone-800">
                    <button wire:click="$set('showForm', false)"
                        class="px-4 py-2 rounded-lg bg-stone-800 text-sm">{{ __('messages.admin.cancel') }}</button>
                    @canany(['branches.create', 'branches.update'])
<button wire:click="save"
                        class="px-4 py-2 rounded-lg bg-yellow-500 text-stone-950 font-bold text-sm">{{ __('messages.admin.save') }}</button>
@endcanany
                </div>
            </div>
        </div>
    @endif
</div>