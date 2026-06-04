@props(['title' => null])
<!DOCTYPE html>
<html lang="{{ app()->getLocale() }}" dir="{{ app()->getLocale() === 'ar' ? 'rtl' : 'ltr' }}" class="h-full">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>{{ $title ?? __('messages.admin.dashboard') }} — Iraq Max Tire</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link
        href="https://fonts.googleapis.com/css2?family=Almarai:wght@300;400;700;800&family=Inter:wght@300;400;500;600;700;800&display=swap"
        rel="stylesheet">

    @vite(['resources/css/app.css', 'resources/js/app.js'])
    @livewireStyles

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">

    <style>
        body {
            font-family: 'Almarai', 'Inter', system-ui, sans-serif;
        }
    </style>
</head>

<body class="bg-stone-950 text-stone-100 antialiased min-h-full">
    {{ $slot }}

    @livewireScripts
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
    <script>
        document.addEventListener('livewire:init', () => {
            Livewire.on('toast', ({ icon = 'success', title = '' } = {}) => {
                Swal.fire({
                    toast: true,
                    position: '{{ app()->getLocale() === 'ar' ? 'top-start' : 'top-end' }}',
                    icon, title,
                    showConfirmButton: false,
                    timer: 2500,
                    timerProgressBar: true,
                    background: '#1c1917',
                    color: '#fafaf9',
                });
            });

            Livewire.on('confirm-delete', ({ id, message }) => {
                Swal.fire({
                    title: message || '{{ __('messages.admin.confirm_delete') }}',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: '{{ __('messages.admin.yes_delete') }}',
                    cancelButtonText: '{{ __('messages.admin.cancel') }}',
                    confirmButtonColor: '#eab308',
                    cancelButtonColor: '#57534e',
                    background: '#1c1917',
                    color: '#fafaf9',
                }).then((res) => {
                    if (res.isConfirmed) {
                        Livewire.dispatch('delete-confirmed', { id });
                    }
                });
            });
        });

        @if (session('toast'))
            document.addEventListener('DOMContentLoaded', () => {
                Swal.fire({
                    toast: true,
                    position: '{{ app()->getLocale() === 'ar' ? 'top-start' : 'top-end' }}',
                    icon: '{{ session('toast.icon', 'success') }}',
                    title: @json(session('toast.title')),
                    showConfirmButton: false,
                    timer: 2500,
                    background: '#1c1917',
                    color: '#fafaf9',
                });
            });
        @endif
    </script>
</body>

</html>