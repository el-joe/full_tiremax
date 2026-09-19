@php
    $nav = [
        ['can' => 'dashboard.view', 'route' => 'admin.dashboard', 'label' => __('messages.admin.dashboard'), 'icon' => 'M3 12l9-9 9 9M5 10v10h14V10'],
        ['can' => 'products.view', 'route' => 'admin.products.index', 'label' => __('messages.admin.products'), 'icon' => 'M20 7L12 3 4 7m16 0l-8 4m8-4v10l-8 4m0-14L4 7m8 4v10m0-10L4 7v10l8 4'],
        ['can' => 'fitments.view', 'route' => 'admin.fitments.index', 'label' => __('messages.admin.fitments'), 'icon' => 'M9 12h6m-6 4h6m-6-8h6M5 4h14a2 2 0 012 2v14l-4-2-4 2-4-2-4 2V6a2 2 0 012-2z'],
        ['can' => 'vehicles.view', 'route' => 'admin.vehicles.index', 'label' => __('messages.admin.vehicles'), 'icon' => 'M3 13l2-7h14l2 7M5 13h14v6H5v-6zM7 17h.01M17 17h.01'],
        ['can' => 'vehicles.view', 'route' => 'admin.vehicle-makes.index', 'label' => __('messages.admin.vehicle_makes'), 'icon' => 'M5 13l4 4L19 7'],
        ['can' => 'vehicles.view', 'route' => 'admin.vehicle-models.index', 'label' => __('messages.admin.vehicle_models'), 'icon' => 'M5 13l4 4L19 7'],
        ['can' => 'brands.view', 'route' => 'admin.brands.index', 'label' => __('messages.admin.brands'), 'icon' => 'M5 7h14l-1.5 12h-11L5 7zM9 7V5a3 3 0 016 0v2'],
        ['can' => 'categories.view', 'route' => 'admin.categories.index', 'label' => __('messages.admin.categories'), 'icon' => 'M4 6h16M4 12h16M4 18h16'],
        ['can' => 'orders.view', 'route' => 'admin.orders.index', 'label' => __('messages.admin.orders'), 'icon' => 'M9 5h6a2 2 0 012 2v12l-5-3-5 3V7a2 2 0 012-2z'],
        ['can' => 'bookings.view', 'route' => 'admin.bookings.index', 'label' => __('messages.admin.bookings'), 'icon' => 'M8 7V3m8 4V3M5 11h14M5 7h14a2 2 0 012 2v10a2 2 0 01-2 2H5a2 2 0 01-2-2V9a2 2 0 012-2z'],
        ['can' => 'customers.view', 'route' => 'admin.customers.index', 'label' => __('messages.admin.customers'), 'icon' => 'M16 11a4 4 0 11-8 0 4 4 0 018 0zM12 14c-4 0-7 2-7 5v1h14v-1c0-3-3-5-7-5z'],
        ['can' => 'branches.view', 'route' => 'admin.branches.index', 'label' => __('messages.admin.branches'), 'icon' => 'M3 21V8l9-5 9 5v13M9 21V12h6v9'],
        ['can' => 'governorates.view', 'route' => 'admin.governorates.index', 'label' => __('messages.admin.governorates'), 'icon' => 'M12 2C8 6 6 9 6 12c0 4 3 7 6 10 3-3 6-6 6-10 0-3-2-6-6-10zm0 12a2 2 0 100-4 2 2 0 000 4z'],
        ['can' => 'services.view', 'route' => 'admin.services.index', 'label' => __('messages.admin.services'), 'icon' => 'M11 3.05A9 9 0 1020.95 13M20.95 13H11V3.05'],
        ['can' => 'offers.view', 'route' => 'admin.offers.index', 'label' => __('messages.admin.offers'), 'icon' => 'M7 7h.01M7 3h5l9 9-9 9-9-9V3z'],
        ['can' => 'flash_sales.view', 'route' => 'admin.flash-sales.index', 'label' => __('messages.admin.flash_sales'), 'icon' => 'M13 10V3L4 14h7v7l9-11h-7z'],
        ['can' => 'reviews.view', 'route' => 'admin.reviews.index', 'label' => __('messages.admin.reviews'), 'icon' => 'M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.914c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.196-1.539-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.783-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z'],
        ['can' => 'daftra_logs.view', 'route' => 'admin.daftra-logs.index', 'label' => __('messages.admin.daftra_logs'), 'icon' => 'M4 4v16h16M8 16l3-4 3 3 4-6'],
        ['can' => 'whatsapp.view', 'route' => 'admin.whatsapp-templates.index', 'label' => __('messages.admin.whatsapp'), 'icon' => 'M20 12a8 8 0 11-15.5-3M4 4l1.5 5L11 8'],
        ['can' => 'whatsapp.view', 'route' => 'admin.whatsapp-logs.index', 'label' => __('messages.admin.whatsapp_logs'), 'icon' => 'M20 12a8 8 0 11-15.5-3M4 4l1.5 5L11 8'],
        ['can' => 'payment_gateways.view', 'route' => 'admin.payment-gateways.index', 'label' => __('messages.admin.payment_gateways'), 'icon' => 'M3 10h18M5 6h14a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2V8a2 2 0 012-2zM7 15h4'],
        ['can' => 'admins.view', 'route' => 'admin.admins.index', 'label' => __('messages.admin.admins'), 'icon' => 'M12 4a4 4 0 100 8 4 4 0 000-8zM4 20c0-4 4-6 8-6s8 2 8 6'],
        ['can' => 'roles.view', 'route' => 'admin.roles.index', 'label' => __('messages.admin.roles'), 'icon' => 'M12 3l8 4v5c0 5-3.5 8-8 9-4.5-1-8-4-8-9V7l8-4z'],
        ['can' => 'audit_logs.view', 'route' => 'admin.audit-logs.index', 'label' => __('messages.admin.audit_logs'), 'icon' => 'M9 12h6M9 16h6M7 3h7l5 5v13H7z'],
        ['can' => 'settings.view', 'route' => 'admin.settings.index', 'label' => __('messages.admin.settings'), 'icon' => 'M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065zM15 12a3 3 0 11-6 0 3 3 0 016 0z'],
    ];
@endphp
<aside
    class="fixed inset-y-0 {{ app()->getLocale() === 'ar' ? 'right-0' : 'left-0' }} w-64 bg-stone-900 border-{{ app()->getLocale() === 'ar' ? 'l' : 'r' }} border-stone-800 hidden lg:flex flex-col z-30">
    <div class="h-16 flex items-center justify-center border-b border-stone-800 px-4">
        <div class="flex items-center gap-2">
            <div class="w-8 h-8 rounded-lg bg-yellow-500 flex items-center justify-center">
                <span class="text-stone-950 font-extrabold">M</span>
            </div>
            <div>
                <div class="text-sm font-extrabold text-yellow-500 leading-none">Iraq Max Tire</div>
                <div class="text-[10px] text-stone-500">{{ __('messages.admin.dashboard') }}</div>
            </div>
        </div>
    </div>
    <nav class="flex-1 overflow-y-auto py-4 px-2 space-y-1 text-sm">
        @php $nav = array_values(array_filter($nav, fn ($i) => auth('admin')->user()?->can($i['can']))); @endphp
        @foreach ($nav as $item)
            @php $active = request()->routeIs($item['route']); @endphp
            <a href="{{ route($item['route']) }}"
                class="flex items-center gap-3 px-3 py-2 rounded-lg transition
                              {{ $active ? 'bg-yellow-500 text-stone-950 font-bold' : 'text-stone-300 hover:bg-stone-800 hover:text-yellow-500' }}">
                <svg class="w-5 h-5 shrink-0" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="{{ $item['icon'] }}" />
                </svg>
                <span>{{ $item['label'] }}</span>
            </a>
        @endforeach
    </nav>
    <div class="p-3 border-t border-stone-800 text-xs text-stone-500">
        v1.0 · {{ now()->year }}
    </div>
</aside>