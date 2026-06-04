@props(['title' => null])
<x-admin.base :title="$title">
    <div class="flex min-h-screen">
        @include('admin.partials.sidebar')

        <div class="flex-1 flex flex-col {{ app()->getLocale() === 'ar' ? 'lg:mr-64' : 'lg:ml-64' }}">
            @include('admin.partials.topbar')

            <main class="flex-1 px-4 sm:px-6 lg:px-8 py-6">
                {{ $slot }}
            </main>
        </div>
    </div>
</x-admin.base>