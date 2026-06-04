<div class="min-h-screen flex items-center justify-center px-4">
    <div class="w-full max-w-md">
        <div class="bg-stone-900 rounded-2xl border border-stone-800 p-8 shadow-2xl">
            <div class="text-center mb-6">
                <div class="w-14 h-14 mx-auto rounded-2xl bg-yellow-500 flex items-center justify-center mb-3">
                    <span class="text-2xl font-extrabold text-stone-950">M</span>
                </div>
                <h1 class="text-xl font-bold text-stone-100">{{ __('messages.admin.login_title') }}</h1>
                <p class="text-sm text-stone-400 mt-1">Iraq Max Tire</p>
            </div>

            <form wire:submit="submit" class="space-y-4">
                <div>
                    <label class="block text-sm text-stone-300 mb-1">{{ __('messages.admin.email') }}</label>
                    <input type="email" wire:model="email" autocomplete="username"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-stone-100 focus:border-yellow-500 focus:outline-none">
                    @error('email') <p class="text-red-400 text-xs mt-1">{{ $message }}</p> @enderror
                </div>

                <div>
                    <label class="block text-sm text-stone-300 mb-1">{{ __('messages.admin.password') }}</label>
                    <input type="password" wire:model="password" autocomplete="current-password"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-stone-100 focus:border-yellow-500 focus:outline-none">
                    @error('password') <p class="text-red-400 text-xs mt-1">{{ $message }}</p> @enderror
                </div>

                <label class="flex items-center gap-2 text-sm text-stone-300">
                    <input type="checkbox" wire:model="remember"
                        class="rounded bg-stone-800 border-stone-700 text-yellow-500 focus:ring-yellow-500">
                    {{ __('messages.admin.remember') }}
                </label>

                <button type="submit"
                    class="w-full bg-yellow-500 hover:bg-yellow-400 text-stone-950 font-bold py-2.5 rounded-lg transition">
                    <span wire:loading.remove wire:target="submit">{{ __('messages.admin.sign_in') }}</span>
                    <span wire:loading wire:target="submit">…</span>
                </button>
            </form>
        </div>
    </div>
</div>