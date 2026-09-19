<?php

namespace App\Livewire\Admin\Products;

use App\Models\Brand;
use App\Models\Category;
use App\Models\Product;
use App\Models\ProductBadge;
use Illuminate\Support\Facades\DB;
use Livewire\Attributes\Layout;
use Livewire\Component;

class ProductForm extends Component
{
    use \App\Livewire\Concerns\AuthorizesAdmin;

    public ?int $productId = null;

    public array $form = [
        'type' => 'tire',
        'sku' => '',
        'brand_id' => null,
        'category_id' => null,
        'price' => 0,
        'sale_price' => null,
        'cost' => null,
        'stock' => 0,
        'low_stock_threshold' => 5,
        'manufacture_year' => null,
        'manufacturer_warranty_months' => 0,
        'agency_warranty_months' => 0,
        'expert_rating' => 0,
        'virtual_sales_count' => 0,
        'virtual_views_count' => 0,
        'sort_order' => 0,
        'is_active' => true,
        'is_featured' => false,
        'translations' => [
            'ar' => ['name' => '', 'short_description' => '', 'description' => '', 'pattern_name' => '', 'usage_notes' => ''],
            'en' => ['name' => '', 'short_description' => '', 'description' => '', 'pattern_name' => '', 'usage_notes' => ''],
        ],
        'tire' => ['width' => null, 'aspect_ratio' => null, 'rim_diameter' => null, 'load_index' => null, 'speed_rating' => null, 'usage_type' => 'summer', 'runflat' => false],
        'battery' => ['voltage' => 12, 'ampere_hour' => null, 'cca' => null, 'battery_type' => '', 'terminal_position' => '', 'size_code' => ''],
    ];

    public array $badges = [];

    public function mount(?int $productId = null): void
    {
        $this->authorizePermission($productId ? 'products.update' : 'products.create');
        $this->productId = $productId;
        if ($productId) {
            $p = Product::with(['translations', 'tireSpec', 'batterySpec', 'badges'])->findOrFail($productId);
            $this->form = array_merge($this->form, [
                'type' => $p->type,
                'sku' => $p->sku,
                'brand_id' => $p->brand_id,
                'category_id' => $p->category_id,
                'price' => (float) $p->price,
                'sale_price' => $p->sale_price ? (float) $p->sale_price : null,
                'cost' => $p->cost ? (float) $p->cost : null,
                'stock' => $p->stock,
                'low_stock_threshold' => $p->low_stock_threshold,
                'manufacture_year' => $p->manufacture_year,
                'manufacturer_warranty_months' => $p->manufacturer_warranty_months,
                'agency_warranty_months' => $p->agency_warranty_months,
                'expert_rating' => (float) $p->expert_rating,
                'virtual_sales_count' => $p->virtual_sales_count,
                'virtual_views_count' => $p->virtual_views_count,
                'sort_order' => $p->sort_order,
                'is_active' => $p->is_active,
                'is_featured' => $p->is_featured,
            ]);
            foreach (['ar', 'en'] as $loc) {
                $t = $p->translate($loc);
                $this->form['translations'][$loc] = [
                    'name' => $t->name ?? '',
                    'short_description' => $t->short_description ?? '',
                    'description' => $t->description ?? '',
                    'pattern_name' => $t->pattern_name ?? '',
                    'usage_notes' => $t->usage_notes ?? '',
                ];
            }
            if ($p->tireSpec)
                $this->form['tire'] = $p->tireSpec->only(['width', 'aspect_ratio', 'rim_diameter', 'load_index', 'speed_rating', 'usage_type', 'runflat']);
            if ($p->batterySpec)
                $this->form['battery'] = $p->batterySpec->only(['voltage', 'ampere_hour', 'cca', 'battery_type', 'terminal_position', 'size_code']);
            $this->badges = $p->badges->pluck('badge')->toArray();
        }
    }

    protected function rules(): array
    {
        return [
            'form.type' => ['required', 'in:tire,battery'],
            'form.sku' => ['required', 'string', 'max:80'],
            'form.brand_id' => ['required', 'integer', 'exists:brands,id'],
            'form.category_id' => ['nullable', 'integer', 'exists:categories,id'],
            'form.price' => ['required', 'numeric', 'min:0'],
            'form.stock' => ['integer', 'min:0'],
            'form.translations.ar.name' => ['required', 'string'],
            'form.translations.en.name' => ['required', 'string'],
        ];
    }

    public function save(): mixed
    {
        $this->authorizePermission($this->productId ? 'products.update' : 'products.create');
        $this->validate();
        return DB::transaction(function () {
            $p = $this->productId ? Product::findOrFail($this->productId) : new Product();
            $p->fill([
                'type' => $this->form['type'],
                'sku' => $this->form['sku'],
                'brand_id' => (int) $this->form['brand_id'],
                'category_id' => $this->form['category_id'] ?: null,
                'price' => (float) $this->form['price'],
                'sale_price' => $this->form['sale_price'] !== null && $this->form['sale_price'] !== '' ? (float) $this->form['sale_price'] : null,
                'cost' => $this->form['cost'] !== null && $this->form['cost'] !== '' ? (float) $this->form['cost'] : null,
                'stock' => (int) $this->form['stock'],
                'low_stock_threshold' => (int) $this->form['low_stock_threshold'],
                'manufacture_year' => $this->form['manufacture_year'] ?: null,
                'manufacturer_warranty_months' => (int) $this->form['manufacturer_warranty_months'],
                'agency_warranty_months' => (int) $this->form['agency_warranty_months'],
                'expert_rating' => (float) $this->form['expert_rating'],
                'virtual_sales_count' => (int) $this->form['virtual_sales_count'],
                'virtual_views_count' => (int) $this->form['virtual_views_count'],
                'sort_order' => (int) $this->form['sort_order'],
                'is_active' => (bool) $this->form['is_active'],
                'is_featured' => (bool) $this->form['is_featured'],
            ])->save();
            foreach ($this->form['translations'] as $loc => $tr) {
                $p->translateOrNew($loc)->fill($tr);
            }
            $p->save();

            if ($this->form['type'] === 'tire') {
                $p->tireSpec()->updateOrCreate([], $this->form['tire']);
                $p->batterySpec()->delete();
            } else {
                $p->batterySpec()->updateOrCreate([], $this->form['battery']);
                $p->tireSpec()->delete();
            }

            $p->badges()->delete();
            foreach ($this->badges as $badge) {
                ProductBadge::create(['product_id' => $p->id, 'badge' => $badge]);
            }

            $this->productId = $p->id;
            $this->dispatch('toast', icon: 'success', title: __('messages.success'));
            return redirect()->route('admin.products.edit', $p->id);
        });
    }

    #[Layout('components.admin.layout', ['title' => 'Product'])]
    public function render()
    {
        $brands = Brand::active()->get();
        $categories = Category::where('is_active', true)->get();
        $allBadges = [
            Product::BADGE_BEST_SELLER,
            Product::BADGE_BEST_CHOICE,
            Product::BADGE_SPECIAL_OFFER,
            Product::BADGE_NEW,
        ];
        return view('livewire.admin.products.product-form', compact('brands', 'categories', 'allBadges'));
    }
}
