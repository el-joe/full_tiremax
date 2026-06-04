@props([
    'options'           => [],
    'multiple'          => false,
    'placeholder'       => 'Select...',
    'searchPlaceholder' => 'Search...',
    'searchable'        => true,
    'nullable'          => true,
    'value'             => null,
])
@php
    // Detect wire:model directive and extract the property path
    $wireModel = null;
    $isLive    = false;

    if ($attributes->has('wire:model.live')) {
        $wireModel = $attributes->get('wire:model.live');
        $isLive    = true;
    } elseif ($attributes->has('wire:model.lazy')) {
        $wireModel = $attributes->get('wire:model.lazy');
    } elseif ($attributes->has('wire:model')) {
        $wireModel = $attributes->get('wire:model');
    }

    // Attributes to forward to the root element (excludes wire:model* and our own props)
    $rootAttrs = $attributes->except([
        'wire:model',
        'wire:model.live',
        'wire:model.lazy',
    ]);
@endphp

<div
    {{ $rootAttrs->merge(['class' => 'relative']) }}
    x-data="{
        open: false,
        search: '',
        multiple: {{ $multiple ? 'true' : 'false' }},
        options: {{ Js::from($options) }},
        placeholder: @js($placeholder),

        @if ($wireModel)
        value: $wire.entangle(@js($wireModel)){{ $isLive ? '.live' : '' }},
        @else
        value: {{ Js::from($value ?? ($multiple ? [] : '')) }},
        @endif

        get displayLabel() {
            const vals = this.selectedValues
            if (!vals || !vals.length) return this.placeholder
            return vals.map(v => {
                const opt = this.options.find(o => String(o.value) === String(v))
                return opt ? opt.label : v
            }).join(', ')
        },

        get selectedValues() {
            if (Array.isArray(this.value)) return this.value
            if (this.value === null || this.value === '' || this.value === undefined) return []
            return [this.value]
        },

        get filtered() {
            if (!this.search) return this.options
            const q = this.search.toLowerCase()
            return this.options.filter(o => o.label.toLowerCase().includes(q))
        },

        isSelected(val) {
            return this.selectedValues.some(v => String(v) === String(val))
        },

        select(val) {
            if (this.multiple) {
                const vals = [...this.selectedValues]
                const idx  = vals.findIndex(v => String(v) === String(val))
                if (idx >= 0) vals.splice(idx, 1)
                else vals.push(val)
                this.value = vals
            } else {
                this.value = val
                this.open  = false
                this.search = ''
            }
            this.$dispatch('select-change', { value: this.value })
        },

        clear() {
            this.value = this.multiple ? [] : ''
            this.search = ''
            this.$dispatch('select-change', { value: this.value })
        },

        onOpen() {
            this.open = true
            @if ($searchable)
            this.$nextTick(() => this.$refs.searchInput?.focus())
            @endif
        },
    }"
    @click.outside="open = false; search = ''"
>
    {{-- ── Trigger button ─────────────────────────────────────────────── --}}
    <button
        type="button"
        @click="open ? (open = false) : onOpen()"
        class="w-full bg-stone-800 border border-stone-700 hover:border-stone-600 rounded-lg px-3 py-2 text-sm text-left flex items-center justify-between gap-2 focus:outline-none focus:ring-1 focus:ring-yellow-500/50 transition-colors"
        :class="{ 'border-yellow-500/50 ring-1 ring-yellow-500/30': open }"
    >
        <span
            x-text="displayLabel"
            class="truncate"
            :class="{ 'text-stone-400': !selectedValues.length }"
        ></span>

        <div class="flex items-center gap-1 shrink-0">
            {{-- Clear button --}}
            <span
                x-show="selectedValues.length > 0"
                @click.stop="clear()"
                role="button"
                class="text-stone-500 hover:text-stone-300 p-0.5 rounded transition-colors"
            >
                <svg class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/>
                </svg>
            </span>
            {{-- Chevron --}}
            <svg
                class="w-4 h-4 text-stone-400 transition-transform duration-150"
                :class="{ 'rotate-180': open }"
                fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"
            >
                <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7"/>
            </svg>
        </div>
    </button>

    {{-- ── Dropdown panel ──────────────────────────────────────────────── --}}
    <div
        x-show="open"
        x-transition:enter="transition ease-out duration-100"
        x-transition:enter-start="opacity-0 -translate-y-1 scale-[.98]"
        x-transition:enter-end="opacity-100 translate-y-0 scale-100"
        x-transition:leave="transition ease-in duration-75"
        x-transition:leave-start="opacity-100 translate-y-0 scale-100"
        x-transition:leave-end="opacity-0 -translate-y-1 scale-[.98]"
        style="display:none"
        class="absolute top-full left-0 right-0 z-50 mt-1 bg-stone-800 border border-stone-700 rounded-lg shadow-2xl overflow-hidden"
    >
        @if ($searchable)
        {{-- Search input --}}
        <div class="p-2 border-b border-stone-700/60">
            <input
                type="text"
                x-ref="searchInput"
                x-model="search"
                @click.stop
                @keydown.escape.stop="open = false; search = ''"
                placeholder="{{ $searchPlaceholder }}"
                class="w-full bg-stone-900 border border-stone-700 rounded-md px-3 py-1.5 text-sm text-stone-100 placeholder-stone-500 focus:outline-none focus:border-yellow-500/50"
            >
        </div>
        @endif

        {{-- Options list --}}
        <div class="max-h-56 overflow-y-auto py-1">

            {{-- Nullable blank option --}}
            @if ($nullable)
            <button
                type="button"
                @click="select('')"
                class="w-full flex items-center px-3 py-2 text-sm hover:bg-stone-700/60 transition-colors"
                :class="isSelected('') || !selectedValues.length ? 'text-yellow-400' : 'text-stone-400'"
            >
                <span class="italic">{{ $placeholder }}</span>
            </button>
            @endif

            <template x-for="opt in filtered" :key="opt.value">
                <button
                    type="button"
                    @click="select(opt.value)"
                    class="w-full flex items-center gap-2 px-3 py-2 text-sm hover:bg-stone-700/60 transition-colors"
                    :class="isSelected(opt.value) ? 'text-yellow-400' : 'text-stone-200'"
                >
                    {{-- Checkbox (multiple mode) --}}
                    <span
                        x-show="multiple"
                        class="w-4 h-4 border rounded flex items-center justify-center shrink-0 transition-colors"
                        :class="isSelected(opt.value) ? 'bg-yellow-500 border-yellow-500' : 'border-stone-600 bg-stone-700'"
                    >
                        <svg
                            x-show="isSelected(opt.value)"
                            class="w-2.5 h-2.5 text-stone-900"
                            fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"
                        >
                            <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/>
                        </svg>
                    </span>

                    <span x-text="opt.label" class="text-left truncate"></span>
                </button>
            </template>

            {{-- Empty state --}}
            <div
                x-show="filtered.length === 0"
                class="px-3 py-5 text-sm text-stone-500 text-center"
            >
                No results
            </div>
        </div>

        @if ($multiple)
        {{-- Multiple footer --}}
        <div class="px-3 py-2 border-t border-stone-700/60 flex items-center justify-between">
            <span x-text="selectedValues.length + ' selected'" class="text-xs text-stone-400"></span>
            <button
                type="button"
                @click="open = false"
                class="text-xs font-semibold text-yellow-500 hover:text-yellow-400 transition-colors"
            >Done</button>
        </div>
        @endif
    </div>
</div>
