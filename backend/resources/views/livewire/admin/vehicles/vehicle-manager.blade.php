<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.vehicles') }}</h2>
        <div class="flex gap-2 flex-wrap">
            <select wire:model.live="makeId" class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                <option value="">All makes</option>
                @foreach ($makes as $mk) <option value="{{ $mk->id }}">{{ $mk->name }}</option> @endforeach
            </select>
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
                    <th class="px-4 py-3 text-start">Make</th>
                    <th class="px-4 py-3 text-start">Model</th>
                    <th class="px-4 py-3 text-start">Years</th>
                    <th class="px-4 py-3 text-start">Trim</th>
                    <th class="px-4 py-3 text-end">{{ __('messages.admin.actions') }}</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-800">
                @forelse ($items as $v)
                    <tr class="hover:bg-stone-800/40">
                        <td class="px-4 py-3 text-stone-400">{{ $v->id }}</td>
                        <td class="px-4 py-3">{{ optional($v->make)->name }}</td>
                        <td class="px-4 py-3 font-bold">{{ optional($v->model)->name }}</td>
                        <td class="px-4 py-3 text-stone-400">{{ $v->year_from }}{{ $v->year_to ? ' – ' . $v->year_to : '' }}
                        </td>
                        <td class="px-4 py-3 text-stone-400">{{ optional($v->translate(app()->getLocale()))->trim }}</td>
                        <td class="px-4 py-3 text-end">
                            <button wire:click="edit({{ $v->id }})"
                                class="text-yellow-500 text-xs me-3">{{ __('messages.admin.edit') }}</button>
                            <button wire:click="confirmDelete({{ $v->id }})"
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
                    <div><label class="text-xs text-stone-400">Make</label>
                        <select wire:model.live="form.vehicle_make_id"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                            <option value="">—</option>
                            @foreach ($makes as $mk) <option value="{{ $mk->id }}">{{ $mk->name }}</option> @endforeach
                        </select>
                    </div>
                    <div><label class="text-xs text-stone-400">Model</label>
                        <select wire:model="form.vehicle_model_id"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                            <option value="">—</option>
                            @foreach ($models as $md) <option value="{{ $md->id }}">{{ $md->name }}</option> @endforeach
                        </select>
                    </div>
                    <div><label class="text-xs text-stone-400">Year from</label><input type="number"
                            wire:model="form.year_from"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">Year to</label><input type="number" wire:model="form.year_to"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">Trim (AR)</label><input
                            wire:model="form.translations.ar.trim"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">Trim (EN)</label><input
                            wire:model="form.translations.en.trim"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <label class="flex items-center gap-2 mt-6"><input type="checkbox" wire:model="form.is_active"
                            class="rounded bg-stone-800 text-yellow-500"> Active</label>
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