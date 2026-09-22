<div class="space-y-6">
    <h2 class="text-2xl font-bold text-stone-100">{{ __('messages.admin.dashboard') }}</h2>

    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
        @foreach ([
            ['perm' => 'orders.view', 'label' => __('messages.admin.orders'),    'value' => $stats['orders_today'],    'sub' => 'today',     'color' => 'text-yellow-500'],
            ['perm' => 'orders.view', 'label' => __('messages.admin.pending_orders'),                'value' => $stats['orders_pending'],  'sub' => '',          'color' => 'text-orange-400'],
            ['perm' => 'orders.view', 'label' => __('messages.admin.revenue_month'),               'value' => number_format($stats['revenue_month']) . ' IQD', 'sub' => '', 'color' => 'text-emerald-400'],
            ['perm' => 'bookings.view', 'label' => __('messages.admin.bookings'),  'value' => $stats['bookings_today'],  'sub' => 'today',     'color' => 'text-sky-400'],
            ['perm' => 'products.view', 'label' => __('messages.admin.products'),  'value' => $stats['products_total'],  'sub' => '',          'color' => 'text-stone-200'],
            ['perm' => 'products.view', 'label' => __('messages.admin.low_stock'),                     'value' => $stats['low_stock'],       'sub' => '',          'color' => 'text-amber-400'],
            ['perm' => 'products.view', 'label' => __('messages.admin.out_of_stock'),                  'value' => $stats['out_of_stock'],    'sub' => '',          'color' => 'text-red-400'],
            ['perm' => 'customers.view', 'label' => __('messages.admin.customers'), 'value' => $stats['customers_total'], 'sub' => '',          'color' => 'text-fuchsia-400'],
        ] as $card)
            @can($card['perm'])
            <div class="bg-stone-900 border border-stone-800 rounded-2xl p-4">
                <div class="text-stone-400 text-xs uppercase tracking-wide">{{ $card['label'] }}</div>
                <div class="mt-2 text-2xl font-extrabold {{ $card['color'] }}">{{ $card['value'] }}</div>
                @if ($card['sub']) <div class="text-stone-500 text-xs mt-1">{{ $card['sub'] }}</div> @endif
            </div>
            @endcan
        @endforeach
    </div>

    <div class="grid lg:grid-cols-2 gap-6">
        @can('orders.view')
        <div class="bg-stone-900 border border-stone-800 rounded-2xl p-4">
            <h3 class="font-bold mb-3 text-stone-100">{{ __('messages.admin.orders') }}</h3>
            <div class="divide-y divide-stone-800">
                @forelse ($latestOrders as $o)
                    <div class="py-2 flex items-center justify-between text-sm">
                        <div>
                            <div class="font-bold text-yellow-500">{{ $o->reference }}</div>
                            <div class="text-stone-400 text-xs">{{ $o->customer_name }} @if ($o->is_guest) ({{ __('messages.admin.guest') }}) @endif · {{ $o->created_at->diffForHumans() }}</div>
                        </div>
                        <div class="text-end">
                            <div class="font-bold text-stone-100">{{ number_format($o->total) }} IQD</div>
                            <div class="text-xs text-stone-400">{{ $o->status }}</div>
                        </div>
                    </div>
                @empty
                    <p class="text-stone-500 text-sm py-4">{{ __('messages.admin.no_data') }}</p>
                @endforelse
            </div>
        </div>
        @endcan

        @can('bookings.view')
        <div class="bg-stone-900 border border-stone-800 rounded-2xl p-4">
            <h3 class="font-bold mb-3 text-stone-100">{{ __('messages.admin.bookings') }}</h3>
            <div class="divide-y divide-stone-800">
                @forelse ($latestBookings as $b)
                    <div class="py-2 flex items-center justify-between text-sm">
                        <div>
                            <div class="font-bold text-yellow-500">{{ $b->reference }}</div>
                            <div class="text-stone-400 text-xs">
                                {{ $b->customer_name ?? $b->customer?->name }} @if ($b->is_guest) ({{ __('messages.admin.guest') }}) @endif · {{ optional($b->service)->name }}
                            </div>
                        </div>
                        <div class="text-end">
                            <div class="text-stone-100">{{ optional($b->scheduled_at)->format('Y-m-d H:i') }}</div>
                            <div class="text-xs text-stone-400">{{ $b->status }}</div>
                        </div>
                    </div>
                @empty
                    <p class="text-stone-500 text-sm py-4">{{ __('messages.admin.no_data') }}</p>
                @endforelse
            </div>
        </div>
        @endcan
    </div>
</div>
