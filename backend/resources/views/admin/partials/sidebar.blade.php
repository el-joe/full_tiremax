@php
    $nav = [
        ['route' => 'admin.dashboard', 'label' => __('messages.admin.dashboard'), 'icon' => 'M3 12l9-9 9 9M5 10v10h14V10'],
        ['route' => 'admin.products.index', 'label' => __('messages.admin.products'), 'icon' => 'M20 7L12 3 4 7m16 0l-8 4m8-4v10l-8 4m0-14L4 7m8 4v10m0-10L4 7v10l8 4'],
        ['route' => 'admin.fitments.index', 'label' => __('messages.admin.fitments'), 'icon' => 'M9 12h6m-6 4h6m-6-8h6M5 4h14a2 2 0 012 2v14l-4-2-4 2-4-2-4 2V6a2 2 0 012-2z'],
        ['route' => 'admin.vehicles.index', 'label' => __('messages.admin.vehicles'), 'icon' => 'M3 13l2-7h14l2 7M5 13h14v6H5v-6zM7 17h.01M17 17h.01'],
        ['route' => 'admin.vehicle-makes.index', 'label' => __('messages.admin.vehicle_makes'), 'icon' => 'M5 13l4 4L19 7'],
        ['route' => 'admin.vehicle-models.index', 'label' => __('messages.admin.vehicle_models'), 'icon' => 'M5 13l4 4L19 7'],
        ['route' => 'admin.brands.index', 'label' => __('messages.admin.brands'), 'icon' => 'M5 7h14l-1.5 12h-11L5 7zM9 7V5a3 3 0 016 0v2'],
        ['route' => 'admin.categories.index', 'label' => __('messages.admin.categories'), 'icon' => 'M4 6h16M4 12h16M4 18h16'],
        ['route' => 'admin.orders.index', 'label' => __('messages.admin.orders'), 'icon' => 'M9 5h6a2 2 0 012 2v12l-5-3-5 3V7a2 2 0 012-2z'],
        ['route' => 'admin.bookings.index', 'label' => __('messages.admin.bookings'), 'icon' => 'M8 7V3m8 4V3M5 11h14M5 7h14a2 2 0 012 2v10a2 2 0 01-2 2H5a2 2 0 01-2-2V9a2 2 0 012-2z'],
        ['route' => 'admin.customers.index', 'label' => __('messages.admin.customers'), 'icon' => 'M16 11a4 4 0 11-8 0 4 4 0 018 0zM12 14c-4 0-7 2-7 5v1h14v-1c0-3-3-5-7-5z'],
        ['route' => 'admin.branches.index', 'label' => __('messages.admin.branches'), 'icon' => 'M3 21V8l9-5 9 5v13M9 21V12h6v9'],
        ['route' => 'admin.governorates.index', 'label' => __('messages.admin.governorates'), 'icon' => 'M12 2C8 6 6 9 6 12c0 4 3 7 6 10 3-3 6-6 6-10 0-3-2-6-6-10zm0 12a2 2 0 100-4 2 2 0 000 4z'],
        ['route' => 'admin.services.index', 'label' => __('messages.admin.services'), 'icon' => 'M11 3.05A9 9 0 1020.95 13M20.95 13H11V3.05'],
        ['route' => 'admin.offers.index', 'label' => __('messages.admin.offers'), 'icon' => 'M7 7h.01M7 3h5l9 9-9 9-9-9V3z'],
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