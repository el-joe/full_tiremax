<div class="flex flex-col gap-4" style="height: calc(100vh - 7rem)">

    {{-- Header --}}
    <div class="flex items-center justify-between gap-3 flex-wrap shrink-0">
        <h2 class="text-xl font-bold">Automation</h2>
        <div class="flex gap-2">
            <button wire:click="switchTab('templates')"
                class="px-4 py-2 rounded-lg text-sm font-semibold transition {{ $tab === 'templates' ? 'bg-yellow-500 text-stone-950' : 'bg-stone-800 text-stone-300 hover:bg-stone-700' }}">
                Templates
            </button>
            <button wire:click="switchTab('logs')"
                class="px-4 py-2 rounded-lg text-sm font-semibold transition {{ $tab === 'logs' ? 'bg-yellow-500 text-stone-950' : 'bg-stone-800 text-stone-300 hover:bg-stone-700' }}">
                Logs
            </button>
        </div>
    </div>

    {{-- TEMPLATES TAB --}}
    @if ($tab === 'templates')
        <div class="bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden flex flex-col flex-1 min-h-0">
            <div class="overflow-auto flex-1">
                <table class="w-full text-sm min-w-[600px]">
                    <thead class="bg-stone-800/60 sticky top-0 z-10">
                        <tr>
                            <th class="px-4 py-3 text-start whitespace-nowrap">Key</th>
                            <th class="px-4 py-3 text-start whitespace-nowrap">Trigger</th>
                            <th class="px-4 py-3 text-start">Message (AR)</th>
                            <th class="px-4 py-3 text-start whitespace-nowrap">Active</th>
                            <th class="px-4 py-3 text-end whitespace-nowrap">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-stone-800">
                        @forelse ($templates as $t)
                            <tr class="hover:bg-stone-800/40">
                                <td class="px-4 py-3 font-mono text-yellow-500 whitespace-nowrap">{{ $t->key }}</td>
                                <td class="px-4 py-3 text-stone-300 whitespace-nowrap">
                                    @if ($t->trigger_after_days === 0 || $t->trigger_after_days === null)
                                        <span class="text-emerald-400">Immediately</span>
                                    @else
                                        {{ $t->trigger_after_days }} days
                                        @php
                                            $map = [3 => '(Review)', 90 => '(Budget)', 180 => '(Balance)', 270 => '(Offer)', 365 => '(Tire Change Reminder)'];
                                        @endphp
                                        <span class="text-stone-500 text-xs block">{{ $map[$t->trigger_after_days] ?? '' }}</span>
                                    @endif
                                </td>
                                <td class="px-4 py-3 text-stone-400 max-w-xs truncate">
                                    {{ $t->translations->firstWhere('locale', 'ar')?->body ?? '—' }}
                                </td>
                                <td class="px-4 py-3 whitespace-nowrap">
                                    <button wire:click="toggleTemplate({{ $t->id }})"
                                        class="px-2 py-0.5 rounded-full text-xs font-semibold {{ $t->is_active ? 'bg-emerald-500/20 text-emerald-400' : 'bg-stone-700 text-stone-400' }}">
                                        {{ $t->is_active ? 'Active' : 'Paused' }}
                                    </button>
                                </td>
                                <td class="px-4 py-3 text-end whitespace-nowrap">
                                    <button wire:click="editTemplate({{ $t->id }})"
                                        class="text-yellow-500 text-xs hover:text-yellow-400 transition">Edit</button>
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="5" class="px-4 py-12 text-center text-stone-500">No templates found.</td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>
    @endif

    {{-- LOGS TAB --}}
    @if ($tab === 'logs')
        <div class="flex flex-col sm:flex-row gap-2 shrink-0">
            <input type="search" wire:model.live.debounce.400ms="search" placeholder="Search phone..."
                class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm w-full sm:w-auto">
            <select wire:model.live="logStatus"
                class="bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm text-stone-300 w-full sm:w-auto">
                <option value="">All statuses</option>
                <option value="sent">Sent</option>
                <option value="delivered">Delivered</option>
                <option value="failed">Failed</option>
                <option value="pending">Pending</option>
            </select>
        </div>

        <div class="bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden flex flex-col flex-1 min-h-0">
            <div class="overflow-auto flex-1">
                <table class="w-full text-sm min-w-[640px]">
                    <thead class="bg-stone-800/60 sticky top-0 z-10">
                        <tr>
                            <th class="px-4 py-3 text-start whitespace-nowrap">Phone</th>
                            <th class="px-4 py-3 text-start whitespace-nowrap">Template</th>
                            <th class="px-4 py-3 text-start whitespace-nowrap">Order</th>
                            <th class="px-4 py-3 text-start whitespace-nowrap">Status</th>
                            <th class="px-4 py-3 text-start whitespace-nowrap">Sent at</th>
                            <th class="px-4 py-3 text-end whitespace-nowrap">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-stone-800">
                        @forelse ($logs as $log)
                                        <tr class="hover:bg-stone-800/40">
                                            <td class="px-4 py-3 font-mono whitespace-nowrap">
                                                {{ $log->phone }}
                                                @if ($log->customer)
                                                    <div class="text-xs text-stone-400">{{ $log->customer->name }}</div>
                                                @endif
                                            </td>
                                            <td class="px-4 py-3 text-stone-400 whitespace-nowrap">{{ $log->template?->key ?? '—' }}</td>
                                            <td class="px-4 py-3 whitespace-nowrap">
                                                @if ($log->order)
                                                    <span class="font-mono text-yellow-500 text-xs">{{ $log->order->reference }}</span>
                                                @else
                                                    <span class="text-stone-600">—</span>
                                                @endif
                                            </td>
                                            <td class="px-4 py-3 whitespace-nowrap">
                                                @php
                                                    $statusColors = [
                                                        'sent' => 'bg-blue-500/20 text-blue-400',
                                                        'delivered' => 'bg-emerald-500/20 text-emerald-400',
                                                        'read' => 'bg-emerald-500/30 text-emerald-300',
                                                        'failed' => 'bg-red-500/20 text-red-400',
                                                        'pending' => 'bg-stone-700 text-stone-400',
                                                    ];
                                                @endphp
                            <span
                                                    class="px-2 py-0.5 rounded-full text-xs font-semibold {{ $statusColors[$log->status] ?? 'bg-stone-700 text-stone-400' }}">
                                                    {{ $log->status }}
                                                </span>
                                            </td>
                                            <td class="px-4 py-3 text-xs text-stone-400 whitespace-nowrap">
                                                {{ $log->sent_at?->format('Y-m-d H:i') ?? $log->created_at->format('Y-m-d H:i') }}
                                            </td>
                                            <td class="px-4 py-3 text-end whitespace-nowrap">
                                                @if ($log->status === 'failed')
                                                    <button wire:click="resendLog({{ $log->id }})"
                                                        class="text-yellow-500 text-xs hover:text-yellow-400 transition">Resend</button>
                                                @endif
                                            </td>
                                        </tr>
                        @empty
                            <tr>
                                <td colspan="6" class="px-4 py-12 text-center text-stone-500">No logs found.</td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
            <div class="p-3 border-t border-stone-800 shrink-0">{{ $logs->links() }}</div>
        </div>
    @endif

    {{-- Edit Template Modal --}}
    @if ($showTemplateModal)
        <div class="fixed inset-0 bg-black/60 flex items-center justify-center z-40 p-4"
            wire:click.self="$set('showTemplateModal', false)">
            <div
                class="bg-stone-900 border border-stone-800 rounded-2xl w-full max-w-2xl p-5 sm:p-6 space-y-4 max-h-[90vh] overflow-y-auto">
                <h3 class="text-lg font-bold">Edit Template: <span class="text-yellow-500">{{ $editKey }}</span></h3>

                <div class="grid sm:grid-cols-2 gap-3">
                    <div>
                        <label class="text-xs text-stone-400">Trigger after (days)</label>
                        <input type="number" wire:model="editTriggerDays"
                            class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm mt-1">
                    </div>
                    <div class="flex items-end gap-2 pb-0.5">
                        <label class="flex items-center gap-2 cursor-pointer">
                            <input type="checkbox" wire:model="editIsActive" class="accent-yellow-500 w-4 h-4">
                            <span class="text-sm">Active</span>
                        </label>
                    </div>
                </div>

                <div>
                    <label class="text-xs text-stone-400">Subject (AR)</label>
                    <input wire:model="editSubjectAr"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm mt-1" dir="rtl">
                </div>
                <div>
                    <label class="text-xs text-stone-400 block mb-1">Body (AR)</label>
                    <textarea wire:model="editBodyAr" rows="5" dir="rtl"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm font-mono resize-none"></textarea>
                    <p class="text-xs text-stone-500 mt-1">Variables: @{{customer_name}}, @{{order_ref}}, @{{order_total}},
                        @{{order_date}}, @{{invoice_url}}</p>
                </div>

                <div>
                    <label class="text-xs text-stone-400">Subject (EN)</label>
                    <input wire:model="editSubjectEn"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm mt-1">
                </div>
                <div>
                    <label class="text-xs text-stone-400 block mb-1">Body (EN)</label>
                    <textarea wire:model="editBodyEn" rows="5"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm font-mono resize-none"></textarea>
                </div>

                <div class="flex justify-end gap-3 pt-2">
                    <button wire:click="$set('showTemplateModal', false)"
                        class="px-4 py-2 bg-stone-800 rounded-lg text-sm hover:bg-stone-700 transition">Cancel</button>
                    <button wire:click="saveTemplate"
                        class="px-4 py-2 bg-yellow-500 text-stone-950 font-bold rounded-lg text-sm hover:bg-yellow-400 transition">Save</button>
                </div>
            </div>
        </div>
    @endif
</div>