<div class="space-y-6">
    <div class="flex items-center justify-between">
        <h2 class="text-xl font-bold">{{ $productId ? __('messages.admin.edit') : __('messages.admin.add_new') }} –
            {{ __('messages.admin.products') }}</h2>
        <a href="{{ route('admin.products.index') }}" class="text-sm text-stone-400 hover:text-yellow-500">{{ __('messages.admin.back') }}</a>
    </div>

    <form wire:submit="save" class="space-y-6">
        <div class="bg-stone-900 border border-stone-800 rounded-2xl p-5 grid sm:grid-cols-3 gap-4">
            <div>
                <label class="text-xs text-stone-400">{{ __('messages.admin.type') }}</label>
                <x-admin.select
                    wire:model.live="form.type"
                    :options="[['value' => 'tire', 'label' => __('messages.admin.tire')], ['value' => 'battery', 'label' => __('messages.admin.battery')]]"
                    :searchable="false"
                    :nullable="false"
                    placeholder="{{ __('messages.admin.select_type') }}"
                />
            </div>
            <div><label class="text-xs text-stone-400">{{ __('messages.admin.sku') }}</label><input wire:model="form.sku"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">@error('form.sku')
                    <p class="text-red-400 text-xs">{{ $message }}</p>@enderror</div>
            <div>
                <label class="text-xs text-stone-400">{{ __('messages.admin.brand') }}</label>
                <x-admin.select
                    wire:model="form.brand_id"
                    :options="$brands->map(fn($b) => ['value' => $b->id, 'label' => $b->name])->all()"
                    placeholder="—"
                />
                @error('form.brand_id')<p class="text-red-400 text-xs">{{ $message }}</p>@enderror
            </div>
            <div>
                <label class="text-xs text-stone-400">{{ __('messages.admin.category') }}</label>
                <x-admin.select
                    wire:model="form.category_id"
                    :options="$categories->map(fn($c) => ['value' => $c->id, 'label' => $c->name])->all()"
                    placeholder="—"
                />
            </div>
            <div><label class="text-xs text-stone-400">{{ __('messages.admin.manufacture_year') }}</label><input type="number"
                    wire:model="form.manufacture_year"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
            <div><label class="text-xs text-stone-400">{{ __('messages.admin.expert_rating') }}</label><input type="number" step="0.1"
                    wire:model="form.expert_rating"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
        </div>

        <div class="bg-stone-900 border border-stone-800 rounded-2xl p-5 grid sm:grid-cols-2 gap-4">
            <h3 class="sm:col-span-2 font-bold text-stone-200">{{ __('messages.admin.names_description') }}</h3>
            <div><label class="text-xs text-stone-400">{{ __('messages.admin.name_ar') }}</label><input wire:model="form.translations.ar.name"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">@error('form.translations.ar.name')
                    <p class="text-red-400 text-xs">{{ $message }}</p>@enderror</div>
            <div><label class="text-xs text-stone-400">{{ __('messages.admin.name_en') }}</label><input wire:model="form.translations.en.name"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">@error('form.translations.en.name')
                    <p class="text-red-400 text-xs">{{ $message }}</p>@enderror</div>
            <div><label class="text-xs text-stone-400">{{ __('messages.admin.short_desc_ar') }}</label><textarea
                    wire:model="form.translations.ar.short_description" rows="2"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></textarea></div>
            <div><label class="text-xs text-stone-400">{{ __('messages.admin.short_desc_en') }}</label><textarea
                    wire:model="form.translations.en.short_description" rows="2"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></textarea></div>
            <div><label class="text-xs text-stone-400">{{ __('messages.admin.description_ar') }}</label><textarea
                    wire:model="form.translations.ar.description" rows="4"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></textarea></div>
            <div><label class="text-xs text-stone-400">{{ __('messages.admin.description_en') }}</label><textarea
                    wire:model="form.translations.en.description" rows="4"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></textarea></div>
            <div><label class="text-xs text-stone-400">{{ __('messages.admin.pattern_ar') }}</label><input
                    wire:model="form.translations.ar.pattern_name"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
            <div><label class="text-xs text-stone-400">{{ __('messages.admin.pattern_en') }}</label><input
                    wire:model="form.translations.en.pattern_name"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
        </div>

        <div class="bg-stone-900 border border-stone-800 rounded-2xl p-5 grid sm:grid-cols-4 gap-4">
            <h3 class="sm:col-span-4 font-bold text-stone-200">{{ __('messages.admin.pricing_stock') }}</h3>
            <div><label class="text-xs text-stone-400">{{ __('messages.admin.price') }}</label><input type="number" wire:model="form.price"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">@error('form.price')
                    <p class="text-red-400 text-xs">{{ $message }}</p>@enderror</div>
            <div><label class="text-xs text-stone-400">{{ __('messages.admin.sale_price') }}</label><input type="number"
                    wire:model="form.sale_price"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
            <div><label class="text-xs text-stone-400">{{ __('messages.admin.cost') }}</label><input type="number" wire:model="form.cost"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
            <div><label class="text-xs text-stone-400">{{ __('messages.admin.stock') }}</label><input type="number" wire:model="form.stock"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
            <div><label class="text-xs text-stone-400">{{ __('messages.admin.low_stock_threshold') }}</label><input type="number"
                    wire:model="form.low_stock_threshold"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
            <div><label class="text-xs text-stone-400">{{ __('messages.admin.manuf_warranty') }}</label><input type="number"
                    wire:model="form.manufacturer_warranty_months"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
            <div><label class="text-xs text-stone-400">{{ __('messages.admin.agency_warranty') }}</label><input type="number"
                    wire:model="form.agency_warranty_months"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
            <div><label class="text-xs text-stone-400">{{ __('messages.admin.sort_order') }}</label><input type="number"
                    wire:model="form.sort_order"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
        </div>

        @if ($form['type'] === 'tire')
            <div class="bg-stone-900 border border-stone-800 rounded-2xl p-5 grid sm:grid-cols-4 gap-4">
                <h3 class="sm:col-span-4 font-bold text-stone-200">{{ __('messages.admin.tire_specifications') }}</h3>
                <div><label class="text-xs text-stone-400">{{ __('messages.admin.width') }}</label><input type="number" wire:model="form.tire.width"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                <div><label class="text-xs text-stone-400">{{ __('messages.admin.aspect_ratio') }}</label><input type="number"
                        wire:model="form.tire.aspect_ratio"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                <div><label class="text-xs text-stone-400">{{ __('messages.admin.rim_diameter') }}</label><input type="number"
                        wire:model="form.tire.rim_diameter"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                <div><label class="text-xs text-stone-400">{{ __('messages.admin.load_index') }}</label><input wire:model="form.tire.load_index"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                <div><label class="text-xs text-stone-400">{{ __('messages.admin.speed_rating') }}</label><input wire:model="form.tire.speed_rating"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                <div><label class="text-xs text-stone-400">{{ __('messages.admin.usage') }}</label>
                    <x-admin.select
                        wire:model="form.tire.usage_type"
                        :options="[['value' => 'summer', 'label' => __('messages.admin.summer')], ['value' => 'winter', 'label' => __('messages.admin.winter')], ['value' => 'all_season', 'label' => __('messages.admin.all_season')], ['value' => 'off_road', 'label' => __('messages.admin.off_road')]]"
                        :searchable="false"
                        :nullable="false"
                        placeholder="{{ __('messages.admin.select_usage') }}"
                    />
                </div>
                <label class="flex items-center gap-2 mt-6"><input type="checkbox" wire:model="form.tire.runflat"
                        class="rounded bg-stone-800 text-yellow-500"> {{ __('messages.admin.run_flat') }}</label>
            </div>
        @else
            <div class="bg-stone-900 border border-stone-800 rounded-2xl p-5 grid sm:grid-cols-3 gap-4">
                <h3 class="sm:col-span-3 font-bold text-stone-200">{{ __('messages.admin.battery_specifications') }}</h3>
                <div><label class="text-xs text-stone-400">{{ __('messages.admin.voltage') }}</label><input type="number"
                        wire:model="form.battery.voltage"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                <div><label class="text-xs text-stone-400">{{ __('messages.admin.ampere_hour') }}</label><input type="number"
                        wire:model="form.battery.ampere_hour"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                <div><label class="text-xs text-stone-400">{{ __('messages.admin.cca') }}</label><input type="number" wire:model="form.battery.cca"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                <div><label class="text-xs text-stone-400">{{ __('messages.admin.type') }}</label><input wire:model="form.battery.battery_type"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                <div><label class="text-xs text-stone-400">{{ __('messages.admin.terminal_position') }}</label><input
                        wire:model="form.battery.terminal_position"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                <div><label class="text-xs text-stone-400">{{ __('messages.admin.size_code') }}</label><input wire:model="form.battery.size_code"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
            </div>
        @endif

        <div class="bg-stone-900 border border-stone-800 rounded-2xl p-5">
            <h3 class="font-bold text-stone-200 mb-3">{{ __('messages.admin.badges') }}</h3>
            <div class="flex flex-wrap gap-3">
                @foreach ($allBadges as $badge)
                    <label class="flex items-center gap-2 bg-stone-800 px-3 py-2 rounded-lg cursor-pointer">
                        <input type="checkbox" wire:model="badges" value="{{ $badge }}"
                            class="rounded bg-stone-900 text-yellow-500">
                        <span class="text-sm">{{ str_replace('_', ' ', $badge) }}</span>
                    </label>
                @endforeach
            </div>
        </div>

        <div class="bg-stone-900 border border-stone-800 rounded-2xl p-5 flex flex-wrap items-center gap-4">
            <label class="flex items-center gap-2"><input type="checkbox" wire:model="form.is_active"
                    class="rounded bg-stone-800 text-yellow-500"> {{ __('messages.admin.active') }}</label>
            <label class="flex items-center gap-2"><input type="checkbox" wire:model="form.is_featured"
                    class="rounded bg-stone-800 text-yellow-500"> {{ __('messages.admin.featured') }}</label>
            <div class="ms-auto flex gap-2">
                <a href="{{ route('admin.products.index') }}"
                    class="px-4 py-2 rounded-lg bg-stone-800 text-sm">{{ __('messages.admin.cancel') }}</a>
                <button type="submit"
                    class="px-6 py-2 rounded-lg bg-yellow-500 text-stone-950 font-bold text-sm">{{ __('messages.admin.save') }}</button>
            </div>
        </div>
    </form>
</div>
