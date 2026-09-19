@php $allActions = collect($groups)->flatten()->unique()->values(); @endphp
<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.roles') }}</h2>
        <div class="flex gap-2 flex-wrap">
            <input type="search" wire:model.live.debounce.400ms="search" placeholder="{{ __('messages.admin.search') }}" class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
            @can('roles.create')
            <button wire:click="openCreate" class="bg-yellow-500 hover:bg-yellow-400 text-stone-950 font-bold px-4 py-2 rounded-lg text-sm">+ {{ __('messages.admin.add_new') }}</button>
            @endcan
        </div>
    </div>

    <div class="bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden">
        <table class="w-full text-sm">
            <thead class="bg-stone-800/60 text-stone-300">
                <tr>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.name') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.permissions_count') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.admins_count') }}</th>
                    <th class="px-4 py-3 text-end">{{ __('messages.admin.actions') }}</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-800">
                @forelse ($roles as $r)
                    <tr class="hover:bg-stone-800/40" wire:key="role-{{ $r->id }}">
                        <td class="px-4 py-3 font-bold text-stone-100">{{ $r->name }}
                            @if ($r->name === 'super-admin')<span class="ms-2 px-2 py-0.5 rounded-full text-xs bg-stone-700 text-stone-300">{{ __('messages.admin.system') }}</span>@endif</td>
                        <td class="px-4 py-3 text-stone-400">{{ $r->name === 'super-admin' ? __('messages.admin.all') : $r->permissions_count }}</td>
                        <td class="px-4 py-3 text-stone-400">{{ $counts[$r->id] ?? 0 }}</td>
                        <td class="px-4 py-3 text-end">
                            @if ($r->name !== 'super-admin')
                                @can('roles.update')
                                <button wire:click="edit({{ $r->id }})" class="text-yellow-500 hover:underline text-xs me-3">{{ __('messages.admin.edit') }}</button>
                                @endcan
                                @can('roles.delete')
                                <button wire:click="confirmDelete({{ $r->id }})" class="text-red-400 hover:underline text-xs">{{ __('messages.admin.delete') }}</button>
                                @endcan
                            @endif
                        </td>
                    </tr>
                @empty
                    <tr><td colspan="4" class="px-4 py-8 text-center text-stone-500">{{ __('messages.admin.no_data') }}</td></tr>
                @endforelse
            </tbody>
        </table>
        <div class="p-3">{{ $roles->links() }}</div>
    </div>

    @if ($showForm)
        <div class="fixed inset-0 bg-black/60 flex items-center justify-center z-40 p-4" wire:click.self="$set('showForm', false)">
            <div class="bg-stone-900 border border-stone-800 rounded-2xl w-full max-w-4xl p-6 space-y-4 max-h-[90vh] overflow-y-auto">
                <div class="flex justify-between items-center">
                    <h3 class="text-lg font-bold">{{ $editingId ? __('messages.admin.edit') : __('messages.admin.add_new') }}</h3>
                    <button wire:click="$set('showForm', false)" class="text-stone-400 hover:text-stone-100">✕</button>
                </div>
                <div>
                    <label class="text-xs text-stone-400">{{ __('messages.admin.name') }} <span class="text-stone-600">({{ __('messages.admin.role_name_hint') }})</span></label>
                    <input wire:model="name" class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                    @error('name') <p class="text-red-400 text-xs mt-1">{{ $message }}</p> @enderror
                </div>
                <div class="overflow-x-auto">
                    <table class="w-full text-xs">
                        <thead class="text-stone-400">
                            <tr>
                                <th class="px-2 py-2 text-start">{{ __('messages.admin.module') }}</th>
                                <th class="px-2 py-2">{{ __('messages.admin.select_all') }}</th>
                                @foreach ($allActions as $act)
                                    <th class="px-2 py-2"><button type="button" wire:click="toggleColumn('{{ $act }}')" class="hover:text-yellow-500">{{ $act }}</button></th>
                                @endforeach
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-stone-800">
                            @foreach ($groups as $module => $actions)
                                <tr wire:key="m-{{ $module }}">
                                    <td class="px-2 py-2 font-bold text-stone-200">{{ $module }}</td>
                                    <td class="px-2 py-2 text-center"><button type="button" wire:click="toggleRow('{{ $module }}')" class="text-yellow-500 hover:underline">{{ __('messages.admin.select_all') }}</button></td>
                                    @foreach ($allActions as $act)
                                        <td class="px-2 py-2 text-center">
                                            @if (in_array($act, $actions))
                                                <input type="checkbox" wire:model="permissions" value="{{ $module.'.'.$act }}" class="rounded bg-stone-800 border-stone-700 text-yellow-500">
                                            @endif
                                        </td>
                                    @endforeach
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                    @error('permissions.*') <p class="text-red-400 text-xs mt-1">{{ $message }}</p> @enderror
                </div>
                <div class="flex justify-end gap-2 pt-2 border-t border-stone-800">
                    <button wire:click="$set('showForm', false)" class="px-4 py-2 rounded-lg bg-stone-800 hover:bg-stone-700 text-sm">{{ __('messages.admin.cancel') }}</button>
                    @canany(['roles.create', 'roles.update'])
                    <button wire:click="save" class="px-4 py-2 rounded-lg bg-yellow-500 hover:bg-yellow-400 text-stone-950 font-bold text-sm">{{ __('messages.admin.save') }}</button>
                    @endcanany
                </div>
            </div>
        </div>
    @endif
</div>
