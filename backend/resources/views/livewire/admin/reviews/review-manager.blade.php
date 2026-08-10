<div class="space-y-4">
    <div class="flex items-center justify-between gap-3 flex-wrap">
        <h2 class="text-xl font-bold">{{ __('messages.admin.reviews') }}</h2>
        <div class="flex gap-2 flex-wrap items-center">
            <select wire:model.live="status"
                class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
                <option value="pending">{{ __('messages.admin.pending') }}</option>
                <option value="approved">{{ __('messages.admin.approved') }}</option>
                <option value="rejected">{{ __('messages.admin.rejected') }}</option>
                <option value="all">{{ __('messages.admin.all') }}</option>
            </select>
            <input type="search" wire:model.live.debounce.400ms="search" placeholder="{{ __('messages.admin.search') }}"
                class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">
        </div>
    </div>

    <div class="bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden">
        <table class="w-full text-sm">
            <thead class="bg-stone-800/60 text-stone-300">
                <tr>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.customer') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.product') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.rating') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.comment') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.status') }}</th>
                    <th class="px-4 py-3 text-start">{{ __('messages.admin.date') }}</th>
                    <th class="px-4 py-3 text-end">{{ __('messages.admin.actions') }}</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-stone-800">
                @forelse ($reviews as $r)
                    <tr class="hover:bg-stone-800/40">
                        <td class="px-4 py-3 text-stone-100">{{ $r->customer?->name ?? '—' }}</td>
                        <td class="px-4 py-3 text-stone-400">{{ $r->product?->name ?? '—' }}</td>
                        <td class="px-4 py-3">
                            <span class="text-yellow-500 tracking-tight">
                                {{ str_repeat('★', $r->rating) }}{{ str_repeat('☆', 5 - $r->rating) }}
                            </span>
                        </td>
                        <td class="px-4 py-3 text-stone-400 max-w-xs truncate" title="{{ $r->comment }}">
                            {{ \Illuminate\Support\Str::limit($r->comment, 60) }}
                        </td>
                        <td class="px-4 py-3">
                            @if (is_null($r->is_approved))
                                <span class="px-2 py-0.5 rounded-full text-xs bg-orange-500/20 text-orange-400">{{ __('messages.admin.pending') }}</span>
                            @elseif ($r->is_approved)
                                <span class="px-2 py-0.5 rounded-full text-xs bg-emerald-500/20 text-emerald-400">{{ __('messages.admin.approved') }}</span>
                            @else
                                <span class="px-2 py-0.5 rounded-full text-xs bg-red-500/20 text-red-400">{{ __('messages.admin.rejected') }}</span>
                            @endif
                        </td>
                        <td class="px-4 py-3 text-stone-400">{{ $r->created_at->format('Y-m-d') }}</td>
                        <td class="px-4 py-3 text-end whitespace-nowrap">
                            @if ($r->is_approved !== true)
                                <button wire:click="approve({{ $r->id }})"
                                    class="text-emerald-400 hover:underline text-xs me-3">{{ __('messages.admin.approve') }}</button>
                            @endif
                            @if ($r->is_approved !== false)
                                <button wire:click="reject({{ $r->id }})"
                                    class="text-red-400 hover:underline text-xs me-3">{{ __('messages.admin.reject') }}</button>
                            @endif
                            <button wire:click="confirmDelete({{ $r->id }})"
                                class="text-stone-400 hover:underline text-xs">{{ __('messages.admin.delete') }}</button>
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="7" class="px-4 py-8 text-center text-stone-500">{{ __('messages.admin.no_data') }}</td>
                    </tr>
                @endforelse
            </tbody>
        </table>
        <div class="p-3">{{ $reviews->links() }}</div>
    </div>
</div>
