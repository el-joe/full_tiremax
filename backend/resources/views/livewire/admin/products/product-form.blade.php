<div class="space-y-6">
    <div class="flex items-center justify-between">
        <h2 class="text-xl font-bold">{{ $productId ? __('messages.admin.edit') : __('messages.admin.add_new') }} –
            {{ __('messages.admin.products') }}</h2>
        <a href="{{ route('admin.products.index') }}" class="text-sm text-stone-400 hover:text-yellow-500">← Back</a>
    </div>

    <form wire:submit="save" class="space-y-6">
        <div class="bg-stone-900 border border-stone-800 rounded-2xl p-5 grid sm:grid-cols-3 gap-4">
            <div>
                <label class="text-xs text-stone-400">Type</label>
                <x-admin.select
                    wire:model.live="form.type"
                    :options="[['value' => 'tire', 'label' => 'Tire'], ['value' => 'battery', 'label' => 'Battery']]"
                    :searchable="false"
                    :nullable="false"
                    placeholder="Select type"
                />
            </div>
            <div><label class="text-xs text-stone-400">SKU</label><input wire:model="form.sku"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">@error('form.sku')
                    <p class="text-red-400 text-xs">{{ $message }}</p>@enderror</div>
            <div>
                <label class="text-xs text-stone-400">Brand</label>
                <x-admin.select
                    wire:model="form.brand_id"
                    :options="$brands->map(fn($b) => ['value' => $b->id, 'label' => $b->name])->all()"
                    placeholder="—"
                />
                @error('form.brand_id')<p class="text-red-400 text-xs">{{ $message }}</p>@enderror
            </div>
            <div>
                <label class="text-xs text-stone-400">Category</label>
                <x-admin.select
                    wire:model="form.category_id"
                    :options="$categories->map(fn($c) => ['value' => $c->id, 'label' => $c->name])->all()"
                    placeholder="—"
                />
            </div>
            <div><label class="text-xs text-stone-400">Manufacture year</label><input type="number"
                    wire:model="form.manufacture_year"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
            <div><label class="text-xs text-stone-400">Expert rating (0-5)</label><input type="number" step="0.1"
                    wire:model="form.expert_rating"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
        </div>

        <div class="bg-stone-900 border border-stone-800 rounded-2xl p-5 grid sm:grid-cols-2 gap-4">
            <h3 class="sm:col-span-2 font-bold text-stone-200">Names & Description</h3>
            <div><label class="text-xs text-stone-400">Name (AR)</label><input wire:model="form.translations.ar.name"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">@error('form.translations.ar.name')
                    <p class="text-red-400 text-xs">{{ $message }}</p>@enderror</div>
            <div><label class="text-xs text-stone-400">Name (EN)</label><input wire:model="form.translations.en.name"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">@error('form.translations.en.name')
                    <p class="text-red-400 text-xs">{{ $message }}</p>@enderror</div>
            <div><label class="text-xs text-stone-400">Short desc (AR)</label><textarea
                    wire:model="form.translations.ar.short_description" rows="2"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></textarea></div>
            <div><label class="text-xs text-stone-400">Short desc (EN)</label><textarea
                    wire:model="form.translations.en.short_description" rows="2"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></textarea></div>
            <div><label class="text-xs text-stone-400">Description (AR)</label><textarea
                    wire:model="form.translations.ar.description" rows="4"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></textarea></div>
            <div><label class="text-xs text-stone-400">Description (EN)</label><textarea
                    wire:model="form.translations.en.description" rows="4"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></textarea></div>
            <div><label class="text-xs text-stone-400">Pattern (AR)</label><input
                    wire:model="form.translations.ar.pattern_name"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
            <div><label class="text-xs text-stone-400">Pattern (EN)</label><input
                    wire:model="form.translations.en.pattern_name"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
        </div>

        <div class="bg-stone-900 border border-stone-800 rounded-2xl p-5 grid sm:grid-cols-4 gap-4">
            <h3 class="sm:col-span-4 font-bold text-stone-200">Pricing & Stock</h3>
            <div><label class="text-xs text-stone-400">Price (IQD)</label><input type="number" wire:model="form.price"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm">@error('form.price')
                    <p class="text-red-400 text-xs">{{ $message }}</p>@enderror</div>
            <div><label class="text-xs text-stone-400">Sale price</label><input type="number"
                    wire:model="form.sale_price"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
            <div><label class="text-xs text-stone-400">Cost</label><input type="number" wire:model="form.cost"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
            <div><label class="text-xs text-stone-400">Stock</label><input type="number" wire:model="form.stock"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
            <div><label class="text-xs text-stone-400">Low-stock threshold</label><input type="number"
                    wire:model="form.low_stock_threshold"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
            <div><label class="text-xs text-stone-400">Manuf. warranty (months)</label><input type="number"
                    wire:model="form.manufacturer_warranty_months"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
            <div><label class="text-xs text-stone-400">Agency warranty (months)</label><input type="number"
                    wire:model="form.agency_warranty_months"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
            <div><label class="text-xs text-stone-400">Sort order</label><input type="number"
                    wire:model="form.sort_order"
                    class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
        </div>

        @if ($form['type'] === 'tire')
            <div class="bg-stone-900 border border-stone-800 rounded-2xl p-5 grid sm:grid-cols-4 gap-4">
                <h3 class="sm:col-span-4 font-bold text-stone-200">Tire Specifications</h3>
                <div><label class="text-xs text-stone-400">Width</label><input type="number" wire:model="form.tire.width"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                <div><label class="text-xs text-stone-400">Aspect ratio</label><input type="number"
                        wire:model="form.tire.aspect_ratio"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                <div><label class="text-xs text-stone-400">Rim diameter</label><input type="number"
                        wire:model="form.tire.rim_diameter"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                <div><label class="text-xs text-stone-400">Load index</label><input wire:model="form.tire.load_index"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                <div><label class="text-xs text-stone-400">Speed rating</label><input wire:model="form.tire.speed_rating"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                <div><label class="text-xs text-stone-400">Usage</label>
                    <x-admin.select
                        wire:model="form.tire.usage_type"
                        :options="[['value' => 'summer', 'label' => 'Summer'], ['value' => 'winter', 'label' => 'Winter'], ['value' => 'all_season', 'label' => 'All-season'], ['value' => 'off_road', 'label' => 'Off-road']]"
                        :searchable="false"
                        :nullable="false"
                        placeholder="Select usage"
                    />
                </div>
                <label class="flex items-center gap-2 mt-6"><input type="checkbox" wire:model="form.tire.runflat"
                        class="rounded bg-stone-800 text-yellow-500"> Run-flat</label>
            </div>
        @else
            <div class="bg-stone-900 border border-stone-800 rounded-2xl p-5 grid sm:grid-cols-3 gap-4">
                <h3 class="sm:col-span-3 font-bold text-stone-200">Battery Specifications</h3>
                <div><label class="text-xs text-stone-400">Voltage</label><input type="number"
                        wire:model="form.battery.voltage"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                <div><label class="text-xs text-stone-400">Ampere-hour</label><input type="number"
                        wire:model="form.battery.ampere_hour"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                <div><label class="text-xs text-stone-400">CCA</label><input type="number" wire:model="form.battery.cca"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                <div><label class="text-xs text-stone-400">Type</label><input wire:model="form.battery.battery_type"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                <div><label class="text-xs text-stone-400">Terminal position</label><input
                        wire:model="form.battery.terminal_position"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
                <div><label class="text-xs text-stone-400">Size code</label><input wire:model="form.battery.size_code"
                        class="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2 text-sm"></div>
            </div>
        @endif

        <div class="bg-stone-900 border border-stone-800 rounded-2xl p-5">
            <h3 class="font-bold text-stone-200 mb-3">Badges</h3>
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
                    class="rounded bg-stone-800 text-yellow-500"> Active</label>
            <label class="flex items-center gap-2"><input type="checkbox" wire:model="form.is_featured"
                    class="rounded bg-stone-800 text-yellow-500"> Featured</label>
            <div class="ms-auto flex gap-2">
                <a href="{{ route('admin.products.index') }}"
                    class="px-4 py-2 rounded-lg bg-stone-800 text-sm">{{ __('messages.admin.cancel') }}</a>
                <button type="submit"
                    class="px-6 py-2 rounded-lg bg-yellow-500 text-stone-950 font-bold text-sm">{{ __('messages.admin.save') }}</button>
            </div>
        </div>
    </form>
</div>
