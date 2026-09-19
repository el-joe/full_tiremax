<x-admin.base :title="__('messages.admin.forbidden_title')">
    <div class="min-h-screen flex items-center justify-center px-4">
        <div class="text-center max-w-md">
            <div class="text-7xl font-extrabold text-yellow-500">403</div>
            <p class="mt-4 text-stone-300">{{ __('messages.admin.forbidden_text') }}</p>
            @if (auth('admin')->check())
                <a href="{{ route('admin.dashboard') }}"
                    class="inline-block mt-6 px-4 py-2 rounded-lg bg-yellow-500 text-stone-950 font-bold hover:bg-yellow-400">{{ __('messages.admin.back_to_dashboard') }}</a>
            @endif
        </div>
    </div>
</x-admin.base>
