<?php

namespace App\Livewire\Admin\Products;

use App\Livewire\Concerns\WithCrudList;
use App\Models\Brand;
use App\Models\Category;
use App\Models\Product;
use App\Traits\LogsAdminActions;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Attributes\Url;
use Livewire\Component;

class ProductManager extends Component
{
    use \App\Livewire\Concerns\AuthorizesAdmin;

    use WithCrudList, LogsAdminActions;

    #[Url(as: 'type', keep: false)]
    public string $type = '';
    #[Url(as: 'brand', keep: false)]
    public ?int $brandFilter = null;
    #[Url(as: 'category', keep: false)]
    public ?int $categoryFilter = null;
    #[Url(as: 'active', keep: false)]
    public string $activeFilter = '';
    #[Url(as: 'featured', keep: false)]
    public string $featuredFilter = '';
    #[Url(as: 'stock', keep: false)]
    public string $stockFilter = '';
    #[Url(as: 'sale', keep: false)]
    public string $onSale = '';
    #[Url(as: 'price_min', keep: false)]
    public string $priceMin = '';
    #[Url(as: 'price_max', keep: false)]
    public string $priceMax = '';

    protected array $filterKeys = ['type', 'brandFilter', 'categoryFilter', 'activeFilter', 'featuredFilter', 'stockFilter', 'onSale', 'priceMin', 'priceMax'];
    protected array $sortable = ['id', 'sku', 'price', 'stock', 'created_at'];



    public function confirmDelete(int $id): void
    {
        $this->authorizePermission('products.delete');
        $this->dispatch('confirm-delete', id: $id);
    }

    #[On('delete-confirmed')]
    public function delete(int $id): void
    {
        $this->authorizePermission('products.delete');
        $product = Product::with('translations')->findOrFail($id);
        $this->logAction('product.deleted', $product, ['name' => $product->name, 'sku' => $product->sku]);
        $product->delete();
        $this->dispatch('toast', icon: 'success', title: __('messages.deleted'));
    }

    public function toggleActive(int $id): void
    {
        $this->authorizePermission('products.update');
        $p = Product::findOrFail($id);
        $wasActive = $p->is_active;
        $p->is_active = !$p->is_active;
        $p->save();
        $this->logAction('product.toggled', $p, ['is_active' => $wasActive], ['is_active' => $p->is_active]);
        $this->dispatch('toast', icon: 'success', title: __('messages.success'));
    }

    #[Layout('components.admin.layout', ['title' => 'Products'])]
    public function render()
    {
        $this->authorizePermission('products.view');
        $items = Product::query()
            ->with(['translations','brand.translations', 'category.translations', 'tireSpec'])
            ->when($this->type !== '', fn ($q) => $q->where('type', $this->type))
            ->when($this->brandFilter, fn ($q) => $q->where('brand_id', $this->brandFilter))
            ->when($this->categoryFilter, fn ($q) => $q->where('category_id', $this->categoryFilter))
            ->when($this->activeFilter !== '', fn ($q) => $q->where('is_active', $this->activeFilter === '1'))
            ->when($this->featuredFilter !== '', fn ($q) => $q->where('is_featured', $this->featuredFilter === '1'))
            ->when($this->stockFilter === 'in', fn ($q) => $q->where('stock', '>', 5))
            ->when($this->stockFilter === 'low', fn ($q) => $q->where('stock', '>', 0)->where('stock', '<=', 5))
            ->when($this->stockFilter === 'out', fn ($q) => $q->where('stock', '<=', 0))
            ->when($this->onSale === '1', fn ($q) => $q->whereNotNull('sale_price')->where('sale_price', '>', 0))
            ->when($this->onSale === '0', fn ($q) => $q->where(fn ($w) => $w->whereNull('sale_price')->orWhere('sale_price', '<=', 0)))
            ->when(is_numeric($this->priceMin), fn ($q) => $q->where('price', '>=', $this->priceMin))
            ->when(is_numeric($this->priceMax), fn ($q) => $q->where('price', '<=', $this->priceMax))
            ->searchTranslated($this->search, ['name'], ['sku'])
            ->tap(fn ($q) => $this->applySort($q))
            ->paginate($this->pageSize());

        $brands = Brand::active()->with('translations')->get();
        $categories = Category::where('is_active', true)->with('translations')->get();

        return view('livewire.admin.products.product-manager', compact('items', 'brands', 'categories'));
    }
}
