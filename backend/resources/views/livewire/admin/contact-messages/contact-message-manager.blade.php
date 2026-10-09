@php
    $statusClasses = [
        'new' => 'bg-orange-500/20 text-orange-400',
        'read' => 'bg-sky-500/20 text-sky-400',
        'replied' => 'bg-emerald-500/20 text-emerald-400',
        'archived' => 'bg-stone-500/20 text-stone-400',
    ];
@endphp
<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.contact_messages') }}</h2>
        <div class="flex gap-2 flex-wrap items-center">
            <x-admin.filter-bar :active="$this->hasActiveFilters()" :total="$messages->total()">
                <x-admin.select wire:model.live="status" :options="[['value' => 'new', 'label' => __('messages.admin.new')], ['value' => 'read', 'label' => __('messages.admin.read')], ['value' => 'replied', 'label' => __('messages.admin.replied')], ['value' => 'archived', 'label' => __('messages.admin.archived')]]" :searchable="false" placeholder="{{ __('messages.admin.status') }}" class="w-36" />
            </x-admin.filter-bar>
        </div>
    </div>

    <div class="bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden">
        <table class="w-full text-sm">
            <thead class="bg-stone-800/60 text-stone-300">
                <tr>
                    <th class="px-4 py-3 text-start cursor-pointer" wire:click="sort('name')">{{ __('messages.admin.name') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.phone') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.contact_subject') }}</th>
                    <th class="px-4 py-3 text-start cursor-pointer" wire:click="sort('status')">{{ __('messages.admin.status') }}</th>
                    <th class="px-4 py-3 text-start cursor-pointer" wire:click="sort('created_at')">{{ __('messages.admin.date') }}</th>
                    <th class="px-4 py-3 text-end">{{ __('messages.admin.actions') }}</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-800">
                @forelse ($messages as $m)
                    <tr class="hover:bg-stone-800/40 {{ $m->status === 'new' ? 'font-semibold' : '' }}">
                        <td class="px-4 py-3 text-stone-100">{{ $m->name }}</td>
                        <td class="px-4 py-3 text-stone-400" dir="ltr">{{ $m->phone }}</td>
                        <td class="px-4 py-3 text-stone-400 max-w-xs truncate" title="{{ $m->subject }}">{{ \Illuminate\Support\Str::limit($m->subject, 60) }}</td>
                        <td class="px-4 py-3">
                            <span class="px-2 py-0.5 rounded-full text-xs {{ $statusClasses[$m->status] ?? $statusClasses['archived'] }}">{{ __('messages.admin.' . $m->status) }}</span>
                        </td>
                        <td class="px-4 py-3 text-stone-400">{{ $m->created_at->format('Y-m-d H:i') }}</td>
                        <td class="px-4 py-3 text-end whitespace-nowrap">
                            <button wire:click="view({{ $m->id }})" class="text-yellow-500 hover:underline text-xs me-3">{{ __('messages.admin.view') }}</button>
                            @can('contact_messages.delete')
                                <button wire:click="confirmDelete({{ $m->id }})" class="text-stone-400 hover:underline text-xs">{{ __('messages.admin.delete') }}</button>
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
        <div class="p-3">{{ $messages->links() }}</div>
    </div>

    {{-- Detail modal --}}
    @if ($viewing)
        <div class="fixed inset-0 bg-black/60 flex items-center justify-center z-40 p-4" wire:click.self="closeView">
            <div class="bg-stone-900 border border-stone-800 rounded-2xl w-full max-w-2xl p-6 space-y-5 max-h-[90vh] overflow-y-auto">
                <div class="flex items-center justify-between">
                    <h3 class="text-lg font-bold">{{ $viewing->subject }}</h3>
                    <button wire:click="closeView" class="text-stone-400 hover:text-stone-100">✕</button>
                </div>

                <div class="grid sm:grid-cols-2 gap-3 text-sm">
                    <div>
                        <div class="text-xs text-stone-400">{{ __('messages.admin.name') }}</div>
                        <div class="text-stone-100">{{ $viewing->name }}</div>
                    </div>
                    <div>
                        <div class="text-xs text-stone-400">{{ __('messages.admin.phone') }}</div>
                        <div class="text-stone-100" dir="ltr">{{ $viewing->phone }}</div>
                    </div>
                    <div>
                        <div class="text-xs text-stone-400">{{ __('messages.admin.date') }}</div>
                        <div class="text-stone-100">{{ $viewing->created_at->format('Y-m-d H:i') }}</div>
                    </div>
                    <div>
                        <div class="text-xs text-stone-400">{{ __('messages.admin.status') }}</div>
                        <span class="px-2 py-0.5 rounded-full text-xs {{ $statusClasses[$viewing->status] ?? $statusClasses['archived'] }}">{{ __('messages.admin.' . $viewing->status) }}</span>
                    </div>
                    @if ($viewing->customer)
                        <div>
                            <div class="text-xs text-stone-400">{{ __('messages.admin.from_customer') }}</div>
                            <div class="text-stone-100">{{ $viewing->customer->name }}</div>
                        </div>
                    @endif
                    @if ($viewing->ip_address)
                        <div>
                            <div class="text-xs text-stone-400">{{ __('messages.admin.ip_address') }}</div>
                            <div class="text-stone-100" dir="ltr">{{ $viewing->ip_address }}</div>
                        </div>
                    @endif
                </div>

                <div>
                    <div class="text-xs text-stone-400 mb-1">{{ __('messages.admin.message') }}</div>
                    <div class="bg-stone-800/60 rounded-lg p-3 text-sm text-stone-100 whitespace-pre-line break-words">{{ $viewing->message }}</div>
                </div>

                @can('contact_messages.manage')
                    <div>
                        <div class="text-xs text-stone-400 mb-1">{{ __('messages.admin.mark_as') }}</div>
                        <div class="flex gap-2 flex-wrap">
                            @foreach (\App\Models\ContactMessage::STATUSES as $s)
                                <button wire:click="setStatus({{ $viewing->id }}, '{{ $s }}')"
                                    class="px-3 py-1 rounded-lg text-xs border {{ $viewing->status === $s ? 'border-yellow-500 text-yellow-500' : 'border-stone-700 text-stone-300 hover:border-stone-500' }}">{{ __('messages.admin.' . $s) }}</button>
                            @endforeach
                        </div>
                    </div>

                    <div>
                        <label class="text-xs text-stone-400">{{ __('messages.admin.admin_notes') }}</label>
                        <textarea wire:model="adminNotes" rows="3"
                            class="w-full mt-1 bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm text-stone-100"></textarea>
                        @error('adminNotes') <p class="text-xs text-red-400 mt-1">{{ $message }}</p> @enderror
                    </div>
                @else
                    @if ($viewing->admin_notes)
                        <div>
                            <div class="text-xs text-stone-400 mb-1">{{ __('messages.admin.admin_notes') }}</div>
                            <div class="text-sm text-stone-100 whitespace-pre-line">{{ $viewing->admin_notes }}</div>
                        </div>
                    @endif
                @endcan

                <div class="flex justify-end gap-2">
                    <button wire:click="closeView" class="px-4 py-2 rounded-lg text-sm text-stone-300 hover:bg-stone-800">{{ __('messages.admin.close') }}</button>
                    @can('contact_messages.manage')
                        <button wire:click="saveNotes" class="px-4 py-2 rounded-lg text-sm bg-yellow-500 text-stone-950 font-bold">{{ __('messages.admin.save') }}</button>
                    @endcan
                </div>
            </div>
        </div>
    @endif
</div>
