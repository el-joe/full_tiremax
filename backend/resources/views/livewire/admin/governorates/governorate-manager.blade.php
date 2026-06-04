<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.governorates') }}</h2>
        <div class="flex gap-2">
            <input type="search" wire:model.live.debounce.400ms="search" placeholder="{{ __('messages.admin.search') }}"
                class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
            <button wire:click="openCreate"
                class="bg-yellow-500 text-stone-950 font-bold px-4 py-2 rounded-lg text-sm">+
                {{ __('messages.admin.add_new') }}</button>
        </div>
    </div>
    <div class="bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden">
        <table class="w-full text-sm">
            <thead class="bg-stone-800/60">
                <tr>
                    <th class="px-4 py-3 text-start">#</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.name') }}</th>
                    <th class="px-4 py-3 text-start">Code</th>
                    <th class="px-4 py-3 text-start">Shipping</th>
                    <th class="px-4 py-3 text-start">Basra</th>
                    <th class="px-4 py-3 text-end">{{ __('messages.admin.actions') }}</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-800">
                @forelse ($items as $g)
                    <tr class="hover:bg-stone-800/40">
                        <td class="px-4 py-3 text-stone-400">{{ $g->id }}</td>
                        <td class="px-4 py-3 font-bold">{{ $g->name }}</td>
                        <td class="px-4 py-3 text-stone-400">{{ $g->code }}</td>
                        <td class="px-4 py-3">{{ number_format($g->shipping_fee) }} IQD</td>
                        <td class="px-4 py-3">
                            {!! $g->is_basra ? '<span class="text-emerald-400">✓</span>' : '<span class="text-stone-500">—</span>' !!}
                        </td>
                        <td class="px-4 py-3 text-end">
                            <button wire:click="edit({{ $g->id }})"
                                class="text-yellow-500 text-xs me-3">{{ __('messages.admin.edit') }}</button>
                            <button wire:click="confirmDelete({{ $g->id }})"
                                class="text-red-400 text-xs">{{ __('messages.admin.delete') }}</button>
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
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">@error('form.translations.ar.name')
                            <p class="text-red-400 text-xs">{{ $message }}</p>@enderror</div>
                    <div><label class="text-xs text-stone-400">Name (EN)</label><input
                            wire:model="form.translations.en.name"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">@error('form.translations.en.name')
                            <p class="text-red-400 text-xs">{{ $message }}</p>@enderror</div>
                    <div><label class="text-xs text-stone-400">Code</label><input wire:model="form.code"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">@error('form.code')
                            <p class="text-red-400 text-xs">{{ $message }}</p>@enderror</div>
                    <div><label class="text-xs text-stone-400">Shipping fee (IQD)</label><input type="number"
                            wire:model="form.shipping_fee"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">Sort order</label><input type="number"
                            wire:model="form.sort_order"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div class="flex flex-col gap-2 mt-6">
                        <label class="flex items-center gap-2"><input type="checkbox" wire:model="form.is_basra"
                                class="rounded bg-stone-800 border-stone-700 text-yellow-500"> Is Basra</label>
                        <label class="flex items-center gap-2"><input type="checkbox" wire:model="form.is_active"
                                class="rounded bg-stone-800 border-stone-700 text-yellow-500">
                            {{ __('messages.admin.active') }}</label>
                    </div>
                </div>
                <div class="flex justify-end gap-2 pt-2 border-t border-stone-800">
                    <button wire:click="$set('showForm', false)"
                        class="px-4 py-2 rounded-lg bg-stone-800 text-sm">{{ __('messages.admin.cancel') }}</button>
                    <button wire:click="save"
                        class="px-4 py-2 rounded-lg bg-yellow-500 text-stone-950 font-bold text-sm">{{ __('messages.admin.save') }}</button>
                </div>
            </div>
        </div>
    @endif
</div>