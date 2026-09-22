<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.fitments') }}</h2>
        <div class="flex gap-2 flex-wrap items-center">
            <x-admin.filter-bar :active="$this->hasActiveFilters()" :total="$items->total()">
                <x-admin.select wire:model.live="makeId" :options="$makes->map(fn($x) => ['value' => $x->id, 'label' => $x->name])->all()" :searchable="true" placeholder="All makes" class="w-44" />
                <x-admin.select wire:model.live="modelId" :options="$models->map(fn($x) => ['value' => $x->id, 'label' => $x->name])->all()" :searchable="true" placeholder="All models" class="w-44" />
                <x-admin.select wire:model.live="productFilter" :options="$products->map(fn($x) => ['value' => $x->id, 'label' => $x->sku])->all()" :searchable="true" placeholder="All products" class="w-44" />
            </x-admin.filter-bar>
            @can('fitments.create')
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
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.vehicle') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.product') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.years') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.flags') }}</th>
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
                            class="px-2 py-0.5 bg-emerald-500/20 text-emerald-400 rounded-full">{{ __('messages.admin.oem') }}</span> @endif
                            @if ($f->is_alternative) <span
                            class="px-2 py-0.5 bg-sky-500/20 text-sky-400 rounded-full">{{ __('messages.admin.alt') }}</span> @endif
                            @if ($f->is_excluded) <span
                            class="px-2 py-0.5 bg-red-500/20 text-red-400 rounded-full">{{ __('messages.admin.excl') }}</span> @endif
                        </td>
                        <td class="px-4 py-3 text-end">
                            @can('fitments.update')
<button wire:click="edit({{ $f->id }})"
                                class="text-yellow-500 text-xs me-3">{{ __('messages.admin.edit') }}</button>
@endcan
                            @can('fitments.delete')
<button wire:click="confirmDelete({{ $f->id }})"
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
            <div
                class="bg-stone-900 border border-stone-800 rounded-2xl w-full max-w-2xl p-6 space-y-4 max-h-[90vh] overflow-y-auto">
                <h3 class="text-lg font-bold">{{ $editingId ? __('messages.admin.edit') : __('messages.admin.add_new') }}
                </h3>
                <div class="grid sm:grid-cols-2 gap-3">
                    <div class="sm:col-span-2"><label class="text-xs text-stone-400">{{ __('messages.admin.vehicle') }}</label>
                        <x-admin.select wire:model="form.vehicle_id" :options="$vehicles->map(fn($v) => ['value' => $v->id, 'label' => optional($v->make)->name . ' ' . optional($v->model)->name . ' ' . $v->year_from . ($v->year_to ? '-' . $v->year_to : '')])->all()" placeholder="—" />
                    </div>
                    <div class="sm:col-span-2"><label class="text-xs text-stone-400">{{ __('messages.admin.product_tire') }}</label>
                        <x-admin.select wire:model="form.product_id" :options="$products->map(fn($p) => ['value' => $p->id, 'label' => $p->sku . ' – ' . optional($p->brand)->name . ' – ' . $p->name])->all()" placeholder="—" />
                    </div>
                    <div><label class="text-xs text-stone-400">{{ __('messages.admin.year_from') }}</label><input type="number"
                            wire:model="form.year_from"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">{{ __('messages.admin.year_to') }}</label><input type="number" wire:model="form.year_to"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">{{ __('messages.admin.trim') }}</label><input wire:model="form.trim"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div></div>
                    <div><label class="text-xs text-stone-400">{{ __('messages.admin.notes_ar') }}</label><textarea
                            wire:model="form.translations.ar.notes" rows="2"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></textarea>
                    </div>
                    <div><label class="text-xs text-stone-400">{{ __('messages.admin.notes_en') }}</label><textarea
                            wire:model="form.translations.en.notes" rows="2"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></textarea>
                    </div>
                    <div class="sm:col-span-2 flex flex-wrap gap-4">
                        <label class="flex items-center gap-2"><input type="checkbox" wire:model="form.is_oem"
                                class="rounded bg-stone-800 text-yellow-500"> {{ __('messages.admin.oem') }}</label>
                        <label class="flex items-center gap-2"><input type="checkbox" wire:model="form.is_alternative"
                                class="rounded bg-stone-800 text-yellow-500"> {{ __('messages.admin.alternative') }}</label>
                        <label class="flex items-center gap-2"><input type="checkbox" wire:model="form.is_excluded"
                                class="rounded bg-stone-800 text-yellow-500"> {{ __('messages.admin.excluded') }}</label>
                    </div>
                </div>
                <div class="flex justify-end gap-2 pt-2 border-t border-stone-800">
                    <button wire:click="$set('showForm', false)"
                        class="px-4 py-2 rounded-lg bg-stone-800 text-sm">{{ __('messages.admin.cancel') }}</button>
                    @canany(['fitments.create', 'fitments.update'])
<button wire:click="save"
                        class="px-4 py-2 rounded-lg bg-yellow-500 text-stone-950 font-bold text-sm">{{ __('messages.admin.save') }}</button>
@endcanany
                </div>
            </div>
        </div>
    @endif
</div>