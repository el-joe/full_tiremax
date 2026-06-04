<header
    class="h-16 bg-stone-900/80 backdrop-blur border-b border-stone-800 px-4 sm:px-6 flex items-center justify-between sticky top-0 z-20">
    <div class="flex items-center gap-3">
        <h1 class="text-lg font-bold text-stone-100">
            {{ $title ?? __('messages.admin.dashboard') }}
        </h1>
    </div>

    <div class="flex items-center gap-3">
        <form method="POST" action="{{ route('admin.locale.switch', app()->getLocale() === 'ar' ? 'en' : 'ar') }}">
            @csrf
            <button class="px-3 py-1.5 rounded-lg bg-stone-800 hover:bg-stone-700 text-stone-200 text-xs font-bold">
                {{ app()->getLocale() === 'ar' ? 'EN' : 'AR' }}
            </button>
        </form>

        <div class="relative group">
            <button class="flex items-center gap-2 px-3 py-1.5 rounded-lg bg-stone-800 hover:bg-stone-700">
                <div
                    class="w-7 h-7 rounded-full bg-yellow-500 text-stone-950 flex items-center justify-center font-bold text-sm">
                    {{ mb_substr(auth('admin')->user()->name ?? 'A', 0, 1) }}
                </div>
                <span class="text-sm">{{ auth('admin')->user()->name }}</span>
            </button>
            <div
                class="absolute {{ app()->getLocale() === 'ar' ? 'left-0' : 'right-0' }} mt-1 w-44 bg-stone-900 border border-stone-800 rounded-lg overflow-hidden invisible group-hover:visible">
                <form method="POST" action="{{ route('admin.logout') }}">
                    @csrf
                    <button class="w-full text-start px-4 py-2 hover:bg-stone-800 text-sm text-stone-200">
                        {{ __('messages.admin.logout') }}
                    </button>
                </form>
            </div>
        </div>
    </div>
</header>