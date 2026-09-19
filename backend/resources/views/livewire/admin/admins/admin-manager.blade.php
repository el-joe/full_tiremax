<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.admins') }}</h2>
        <div class="flex gap-2 flex-wrap items-center">
            <x-admin.filter-bar :active="$this->hasActiveFilters()" :total="$admins->total()">
                <select wire:model.live="roleFilter" class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                    <option value="">{{ __('messages.admin.all_roles') }}</option>
                    @foreach ($allRoles as $r)<option value="{{ $r }}">{{ $r }}</option>@endforeach
                </select>
                <select wire:model.live="activeFilter" class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                    <option value="">{{ __('messages.admin.all') }}</option>
                    <option value="1">{{ __('messages.admin.active') }}</option>
                    <option value="0">{{ __('messages.admin.inactive') }}</option>
                </select>
                <select wire:model.live="trashed" class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                    <option value="">{{ __('messages.admin.trashed_none') }}</option>
                    <option value="only">{{ __('messages.admin.trashed_only') }}</option>
                    <option value="with">{{ __('messages.admin.trashed_with') }}</option>
                </select>
            </x-admin.filter-bar>
            @can('admins.create')
            <button wire:click="openCreate" class="bg-yellow-500 hover:bg-yellow-400 text-stone-950 font-bold px-4 py-2 rounded-lg text-sm">+ {{ __('messages.admin.add_new') }}</button>
            @endcan
        </div>
    </div>

    <div class="bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden">
        <table class="w-full text-sm">
            <thead class="bg-stone-800/60 text-stone-300">
                <tr>
                    <th class="px-4 py-3 text-start cursor-pointer" wire:click="sort('id')">#</th>
                    <th class="px-4 py-3 text-start cursor-pointer" wire:click="sort('name')">{{ __('messages.admin.name') }}</th>
                    <th class="px-4 py-3 text-start cursor-pointer" wire:click="sort('email')">{{ __('messages.admin.email') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.roles_label') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.status') }}</th>
                    <th class="px-4 py-3 text-start cursor-pointer" wire:click="sort('last_login_at')">{{ __('messages.admin.last_login') }}</th>
                    <th class="px-4 py-3 text-end">{{ __('messages.admin.actions') }}</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-800">
                @forelse ($admins as $a)
                    <tr class="hover:bg-stone-800/40" wire:key="admin-{{ $a->id }}">
                        <td class="px-4 py-3 text-stone-400">{{ $a->id }}</td>
                        <td class="px-4 py-3"><div class="font-bold text-stone-100">{{ $a->name }}</div><div class="text-xs text-stone-500">{{ $a->phone }}</div></td>
                        <td class="px-4 py-3 text-stone-400">{{ $a->email }}</td>
                        <td class="px-4 py-3">
                            @foreach ($a->roles as $r)
                                <span class="px-2 py-0.5 rounded-full text-xs bg-yellow-500/20 text-yellow-400">{{ $r->name }}</span>
                            @endforeach
                        </td>
                        <td class="px-4 py-3">
                            @if ($a->trashed())
                                <span class="px-2 py-0.5 rounded-full text-xs bg-red-500/20 text-red-400">{{ __('messages.admin.trashed_only') }}</span>
                            @else
                            <span class="px-2 py-0.5 rounded-full text-xs {{ $a->is_active ? 'bg-emerald-500/20 text-emerald-400' : 'bg-stone-700 text-stone-300' }}">
                                {{ $a->is_active ? __('messages.admin.active') : __('messages.admin.inactive') }}
                            </span>
                            @endif
                        </td>
                        <td class="px-4 py-3 text-stone-400 text-xs">{{ $a->last_login_at?->format('Y-m-d H:i') ?? __('messages.admin.never') }}</td>
                        <td class="px-4 py-3 text-end">
                            @if ($a->trashed())
                                @can('admins.delete')
                                <button wire:click="restore({{ $a->id }})" class="text-emerald-400 hover:underline text-xs">{{ __('messages.admin.restore') }}</button>
                                @endcan
                            @else
                                @can('admins.update')
                                <button wire:click="toggleActive({{ $a->id }})" class="text-stone-300 hover:underline text-xs me-3">{{ $a->is_active ? __('messages.admin.inactive') : __('messages.admin.active') }}</button>
                                <button wire:click="edit({{ $a->id }})" class="text-yellow-500 hover:underline text-xs me-3">{{ __('messages.admin.edit') }}</button>
                                @endcan
                                @can('admins.delete')
                                <button wire:click="confirmDelete({{ $a->id }})" class="text-red-400 hover:underline text-xs">{{ __('messages.admin.delete') }}</button>
                                @endcan
                            @endif
                        </td>
                    </tr>
                @empty
                    <tr><td colspan="7" class="px-4 py-8 text-center text-stone-500">{{ __('messages.admin.no_data') }}</td></tr>
                @endforelse
            </tbody>
        </table>
        <div class="p-3">{{ $admins->links() }}</div>
    </div>

    @if ($showForm)
        <div class="fixed inset-0 bg-black/60 flex items-center justify-center z-40 p-4" wire:click.self="$set('showForm', false)">
            <div class="bg-stone-900 border border-stone-800 rounded-2xl w-full max-w-2xl p-6 space-y-4 max-h-[90vh] overflow-y-auto">
                <div class="flex justify-between items-center">
                    <h3 class="text-lg font-bold">{{ $editingId ? __('messages.admin.edit') : __('messages.admin.add_new') }}</h3>
                    <button wire:click="$set('showForm', false)" class="text-stone-400 hover:text-stone-100">✕</button>
                </div>
                <div class="grid sm:grid-cols-2 gap-3">
                    <div>
                        <label class="text-xs text-stone-400">{{ __('messages.admin.name') }}</label>
                        <input wire:model="form.name" class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                        @error('form.name') <p class="text-red-400 text-xs mt-1">{{ $message }}</p> @enderror
                    </div>
                    <div>
                        <label class="text-xs text-stone-400">{{ __('messages.admin.email') }}</label>
                        <input wire:model="form.email" type="email" class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                        @error('form.email') <p class="text-red-400 text-xs mt-1">{{ $message }}</p> @enderror
                    </div>
                    <div>
                        <label class="text-xs text-stone-400">{{ __('messages.admin.phone') }}</label>
                        <input wire:model="form.phone" class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                        @error('form.phone') <p class="text-red-400 text-xs mt-1">{{ $message }}</p> @enderror
                    </div>
                    <div>
                        <label class="text-xs text-stone-400">{{ __('messages.admin.password') }} @if ($editingId)<span class="text-stone-600">({{ __('messages.admin.password_hint') }})</span>@endif</label>
                        <input wire:model="form.password" type="password" autocomplete="new-password" class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                        @error('form.password') <p class="text-red-400 text-xs mt-1">{{ $message }}</p> @enderror
                    </div>
                    <div>
                        <label class="text-xs text-stone-400">{{ __('messages.admin.avatar') }}</label>
                        <input type="file" wire:model="avatarUpload" accept="image/*" class="w-full text-xs text-stone-400">
                        @error('avatarUpload') <p class="text-red-400 text-xs mt-1">{{ $message }}</p> @enderror
                    </div>
                    <label class="flex items-center gap-2 mt-6">
                        <input type="checkbox" wire:model="form.is_active" class="rounded bg-stone-800 border-stone-700 text-yellow-500">
                        <span class="text-sm">{{ __('messages.admin.active') }}</span>
                    </label>
                    @error('form.is_active') <p class="text-red-400 text-xs sm:col-span-2">{{ $message }}</p> @enderror
                </div>
                <div>
                    <label class="text-xs text-stone-400">{{ __('messages.admin.roles_label') }}</label>
                    <div class="flex flex-wrap gap-3 mt-1">
                        @foreach ($allRoles as $r)
                            <label class="flex items-center gap-2 text-sm">
                                <input type="checkbox" wire:model="form.roles" value="{{ $r }}" class="rounded bg-stone-800 border-stone-700 text-yellow-500">
                                {{ $r }}
                            </label>
                        @endforeach
                    </div>
                    @error('form.roles') <p class="text-red-400 text-xs mt-1">{{ $message }}</p> @enderror
                </div>
                <div class="flex justify-end gap-2 pt-2 border-t border-stone-800">
                    <button wire:click="$set('showForm', false)" class="px-4 py-2 rounded-lg bg-stone-800 hover:bg-stone-700 text-sm">{{ __('messages.admin.cancel') }}</button>
                    @canany(['admins.create', 'admins.update'])
                    <button wire:click="save" class="px-4 py-2 rounded-lg bg-yellow-500 hover:bg-yellow-400 text-stone-950 font-bold text-sm">{{ __('messages.admin.save') }}</button>
                    @endcanany
                </div>
            </div>
        </div>
    @endif
</div>
