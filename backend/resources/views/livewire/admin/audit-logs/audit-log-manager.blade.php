<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.audit_logs') }}</h2>
        <div class="flex gap-2 flex-wrap items-center">
            <x-admin.filter-bar :active="$this->hasActiveFilters()" :total="$logs->total()">
                <select wire:model.live="adminFilter" class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                    <option value="">{{ __('messages.admin.all_admins') }}</option>
                    @foreach ($admins as $a)<option value="{{ $a->id }}">{{ $a->name }}</option>@endforeach
                </select>
                <select wire:model.live="actionFilter" class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                    <option value="">{{ __('messages.admin.all_actions') }}</option>
                    @foreach ($actions as $a)<option value="{{ $a }}">{{ $a }}</option>@endforeach
                </select>
                <select wire:model.live="subjectFilter" class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                    <option value="">{{ __('messages.admin.all_subjects') }}</option>
                    @foreach ($subjects as $s)<option value="{{ $s }}">{{ class_basename($s) }}</option>@endforeach
                </select>
                <x-admin.date-range />
            </x-admin.filter-bar>
            
        </div>
    </div>

    <div class="bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden">
        <table class="w-full text-sm">
            <thead class="bg-stone-800/60 text-stone-300">
                <tr>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.date') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.admin') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.action') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.subject') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.ip') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.details') }}</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-800">
                @forelse ($logs as $l)
                    <tr class="hover:bg-stone-800/40 align-top" wire:key="log-{{ $l->id }}">
                        <td class="px-4 py-3 text-stone-400 text-xs whitespace-nowrap">{{ $l->created_at?->format('Y-m-d H:i') }}</td>
                        <td class="px-4 py-3">{{ $l->admin?->name ?? '—' }}</td>
                        <td class="px-4 py-3 font-mono text-xs text-yellow-500">{{ $l->action }}</td>
                        <td class="px-4 py-3 text-stone-400 text-xs">{{ $l->subject_type ? class_basename($l->subject_type).' #'.$l->subject_id : '—' }}</td>
                        <td class="px-4 py-3 text-stone-500 text-xs">{{ $l->ip }}</td>
                        <td class="px-4 py-3 text-stone-400 text-xs font-mono break-all">{{ $l->changes ? \Illuminate\Support\Str::limit(json_encode($l->changes, JSON_UNESCAPED_UNICODE), 160) : '' }}</td>
                    </tr>
                @empty
                    <tr><td colspan="6" class="px-4 py-8 text-center text-stone-500">{{ __('messages.admin.no_data') }}</td></tr>
                @endforelse
            </tbody>
        </table>
        <div class="p-3">{{ $logs->links() }}</div>
    </div>
</div>
