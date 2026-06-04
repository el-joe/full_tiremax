<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.fitments') }}</h2>
        <div class="flex gap-2 flex-wrap">
            <select wire:model.live="makeId" class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                <option value="">All makes</option>
                @foreach ($makes as $mk) <option value="{{ $mk->id }}">{{ $mk->name }}</option> @endforeach
            </select>
            <select wire:model.live="modelId" class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                <option value="">All models</option>
                @foreach ($models as $md) <option value="{{ $md->id }}">{{ $md->name }}</option> @endforeach
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
                    <th class="px-4 py-3 text-start">Vehicle</th>
                    <th class="px-4 py-3 text-start">Product</th>
                    <th class="px-4 py-3 text-start">Years</th>
                    <th class="px-4 py-3 text-start">Flags</th>
                    <th class="px-4 py-3 text-end">{{ __('messages.admin.actions') }}</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-800">
                @forelse ($items as $f)
                    <tr class="hover:bg-stone-800/40">
                        <td class="px-4 py-3 text-stone-400">{{ $f->id }}</td>
                        <td class="px-4 py-3">{{ $f->vehicle?->make?->name }}
                            {{ optional(optional($f->vehicle)->model)->name }}
                        </td>
                        <td class="px-4 py-3 font-bold">{{ optional(optional($f->product)->brand)->name }}
                            {{ optional($f->product)->sku }}
                        </td>
                        <td class="px-4 py-3 text-stone-400">{{ $f->year_from }}{{ $f->year_to ? ' – ' . $f->year_to : '' }}
                        </td>
                        <td class="px-4 py-3 text-xs">
                            @if ($f->is_oem) <span
                            class="px-2 py-0.5 bg-emerald-500/20 text-emerald-400 rounded-full">OEM</span> @endif
                            @if ($f->is_alternative) <span
                            class="px-2 py-0.5 bg-sky-500/20 text-sky-400 rounded-full">ALT</span> @endif
                            @if ($f->is_excluded) <span
                            class="px-2 py-0.5 bg-red-500/20 text-red-400 rounded-full">EXCL</span> @endif
                        </td>
                        <td class="px-4 py-3 text-end">
                            <button wire:click="edit({{ $f->id }})"
                                class="text-yellow-500 text-xs me-3">{{ __('messages.admin.edit') }}</button>
                            <button wire:click="confirmDelete({{ $f->id }})"
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
            <div
                class="bg-stone-900 border border-stone-800 rounded-2xl w-full max-w-2xl p-6 space-y-4 max-h-[90vh] overflow-y-auto">
                <h3 class="text-lg font-bold">{{ $editingId ? __('messages.admin.edit') : __('messages.admin.add_new') }}
                </h3>
                <div class="grid sm:grid-cols-2 gap-3">
                    <div class="sm:col-span-2"><label class="text-xs text-stone-400">Vehicle</label>
                        <select wire:model="form.vehicle_id"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                            <option value="">—</option>
                            @foreach ($vehicles as $v) <option value="{{ $v->id }}">{{ optional($v->make)->name }}
                                {{ optional($v->model)->name }}
                                {{ $v->year_from }}{{ $v->year_to ? '-' . $v->year_to : '' }}
                            </option> @endforeach
                        </select>
                    </div>
                    <div class="sm:col-span-2"><label class="text-xs text-stone-400">Product (Tire)</label>
                        <select wire:model="form.product_id"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                            <option value="">—</option>
                            @foreach ($products as $p) <option value="{{ $p->id }}">{{ $p->sku }} –
                                {{ optional($p->brand)->name }} – {{ $p->name }}
                            </option> @endforeach
                        </select>
                    </div>
                    <div><label class="text-xs text-stone-400">Year from</label><input type="number"
                            wire:model="form.year_from"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">Year to</label><input type="number" wire:model="form.year_to"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">Trim</label><input wire:model="form.trim"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div></div>
                    <div><label class="text-xs text-stone-400">Notes (AR)</label><textarea
                            wire:model="form.translations.ar.notes" rows="2"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></textarea>
                    </div>
                    <div><label class="text-xs text-stone-400">Notes (EN)</label><textarea
                            wire:model="form.translations.en.notes" rows="2"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></textarea>
                    </div>
                    <div class="sm:col-span-2 flex flex-wrap gap-4">
                        <label class="flex items-center gap-2"><input type="checkbox" wire:model="form.is_oem"
                                class="rounded bg-stone-800 text-yellow-500"> OEM</label>
                        <label class="flex items-center gap-2"><input type="checkbox" wire:model="form.is_alternative"
                                class="rounded bg-stone-800 text-yellow-500"> Alternative</label>
                        <label class="flex items-center gap-2"><input type="checkbox" wire:model="form.is_excluded"
                                class="rounded bg-stone-800 text-yellow-500"> Excluded</label>
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