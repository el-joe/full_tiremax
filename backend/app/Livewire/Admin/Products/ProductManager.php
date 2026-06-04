<?php

namespace App\Livewire\Admin\Products;

use App\Livewire\Concerns\WithCrudList;
use App\Models\Brand;
use App\Models\Category;
use App\Models\Product;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Attributes\Url;
use Livewire\Component;

class ProductManager extends Component
{
    use WithCrudList;

    #[Url]
    public string $type = '';
    #[Url]
    public ?int $brandFilter = null;

    public function confirmDelete(int $id): void
    {
        $this->dispatch('confirm-delete', id: $id);
    }

    #[On('delete-confirmed')]
    public function delete(int $id): void
    {
        Product::findOrFail($id)->delete();
        $this->dispatch('toast', icon: 'success', title: __('messages.deleted'));
    }

    public function toggleActive(int $id): void
    {
        $p = Product::findOrFail($id);
        $p->is_active = !$p->is_active;
        $p->save();
        $this->dispatch('toast', icon: 'success', title: __('messages.success'));
    }

    #[Layout('components.admin.layout', ['title' => 'Products'])]
    public function render()
    {
        $items = Product::query()
            ->with(['brand', 'category', 'tireSpec'])
            ->when($this->type, fn($q) => $q->where('type', $this->type))
            ->when($this->brandFilter, fn($q) => $q->where('brand_id', $this->brandFilter))
            ->when($this->search, fn($q) => $q->where(function ($w) {
                $w->where('sku', 'like', "%{$this->search}%")
                    ->orWhereHas('translations', fn($qb) => $qb->where('name', 'like', "%{$this->search}%"));
            }))
            ->orderBy($this->sortBy, $this->sortDir)
            ->paginate(20);

        $brands = Brand::active()->get();
        $categories = Category::where('is_active', true)->get();

        return view('livewire.admin.products.product-manager', compact('items', 'brands', 'categories'));
    }
}
