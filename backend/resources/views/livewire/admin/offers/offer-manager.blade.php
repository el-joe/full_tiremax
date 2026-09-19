<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.offers') }}</h2>
        <div class="flex gap-2"><input type="search" wire:model.live.debounce.400ms="search"
                placeholder="{{ __('messages.admin.search') }}"
                class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">@can('offers.create')
<button
                wire:click="openCreate" class="bg-yellow-500 text-stone-950 font-bold px-4 py-2 rounded-lg text-sm">+
                {{ __('messages.admin.add_new') }}</button>
@endcan</div>
    </div>
    <div class="bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden">
        <table class="w-full text-sm">
            <thead class="bg-stone-800/60">
                <tr>
                    <th class="px-4 py-3 text-start">Code</th>
                    <th class="px-4 py-3 text-start">Title</th>
                    <th class="px-4 py-3 text-start">Discount</th>
                    <th class="px-4 py-3 text-start">Window</th>
                    <th class="px-4 py-3 text-start">Used</th>
                    <th class="px-4 py-3 text-end">{{ __('messages.admin.actions') }}</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-800">
                @forelse ($items as $o)
                    <tr class="hover:bg-stone-800/40">
                        <td class="px-4 py-3 font-mono text-yellow-500">{{ $o->code }}</td>
                        <td class="px-4 py-3 font-bold">{{ $o->title }}</td>
                        <td class="px-4 py-3">
                            {{ $o->discount_type === 'percent' ? $o->discount_value . '%' : number_format($o->discount_value) . ' IQD' }}
                        </td>
                        <td class="px-4 py-3 text-xs text-stone-400">{{ optional($o->starts_at)->format('Y-m-d') ?? '∞' }} →
                            {{ optional($o->ends_at)->format('Y-m-d') ?? '∞' }}
                        </td>
                        <td class="px-4 py-3">{{ $o->used_count }}{{ $o->usage_limit ? '/' . $o->usage_limit : '' }}</td>
                        <td class="px-4 py-3 text-end">
                            @can('offers.update')
<button wire:click="edit({{ $o->id }})"
                                class="text-yellow-500 text-xs me-3">{{ __('messages.admin.edit') }}</button>
@endcan
                            @can('offers.delete')
<button wire:click="confirmDelete({{ $o->id }})"
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
                    <div><label class="text-xs text-stone-400">Code</label><input wire:model="form.code"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">Discount type</label><x-admin.select
                            wire:model="form.discount_type" :options="[['value' => 'percent', 'label' => 'Percent'], ['value' => 'fixed', 'label' => 'Fixed']]" :searchable="false" :nullable="false"
                            placeholder="Select type" /></div>
                    <div><label class="text-xs text-stone-400">Discount value</label><input type="number" step="0.01"
                            wire:model="form.discount_value"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">Min subtotal</label><input type="number"
                            wire:model="form.min_subtotal"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">Title (AR)</label><input
                            wire:model="form.translations.ar.title"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">Title (EN)</label><input
                            wire:model="form.translations.en.title"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">Starts at</label><input type="datetime-local"
                            wire:model="form.starts_at"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">Ends at</label><input type="datetime-local"
                            wire:model="form.ends_at"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <div><label class="text-xs text-stone-400">Usage limit</label><input type="number"
                            wire:model="form.usage_limit"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                    <label class="flex items-center gap-2 mt-6"><input type="checkbox" wire:model="form.is_active"
                            class="rounded bg-stone-800 text-yellow-500"> Active</label>
                </div>
                <div class="flex justify-end gap-2 pt-2 border-t border-stone-800">
                    <button wire:click="$set('showForm', false)"
                        class="px-4 py-2 rounded-lg bg-stone-800 text-sm">{{ __('messages.admin.cancel') }}</button>
                    @canany(['offers.create', 'offers.update'])
<button wire:click="save"
                        class="px-4 py-2 rounded-lg bg-yellow-500 text-stone-950 font-bold text-sm">{{ __('messages.admin.save') }}</button>
@endcanany
                </div>
            </div>
        </div>
    @endif
</div>