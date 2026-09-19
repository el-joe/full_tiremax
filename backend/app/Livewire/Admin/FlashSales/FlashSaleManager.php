<?php

namespace App\Livewire\Admin\FlashSales;

use App\Livewire\Concerns\WithCrudList;
use App\Models\FlashSale;
use App\Models\Product;
use Illuminate\View\View;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;

class FlashSaleManager extends Component
{
    use \App\Livewire\Concerns\AuthorizesAdmin;

    use WithCrudList;

    public bool $showForm = false;

    public array $form = [
        'title' => '',
        'discount_percent' => 10,
        'starts_at' => '',
        'ends_at' => '',
        'is_active' => true,
    ];

    // Product picker state
    public string $productSearch = '';
    public array $productIds = [];   // IDs currently assigned to this flash sale

    protected function rules(): array
    {
        return [
            'form.title' => ['required', 'string', 'max:255'],
            'form.discount_percent' => ['required', 'numeric', 'min:1', 'max:100'],
            'form.starts_at' => ['required', 'date'],
            'form.ends_at' => ['required', 'date', 'after:form.starts_at'],
        ];
    }

    public function openCreate(): void
    {
        $this->authorizePermission('flash_sales.create');
        $this->reset('form', 'editingId', 'productIds', 'productSearch');
        $this->form = [
            'title' => '',
            'discount_percent' => 10,
            'starts_at' => now()->format('Y-m-d\TH:i'),
            'ends_at' => now()->addDay()->format('Y-m-d\TH:i'),
            'is_active' => true,
        ];
        $this->showForm = true;
    }

    public function edit(int $id): void
    {
        $this->authorizePermission('flash_sales.update');
        $sale = FlashSale::with('products')->findOrFail($id);
        $this->editingId = $id;
        $this->productIds = $sale->products->pluck('id')->all();
        $this->productSearch = '';
        $this->form = [
            'title' => $sale->title,
            'discount_percent' => (float) $sale->discount_percent,
            'starts_at' => $sale->starts_at->format('Y-m-d\TH:i'),
            'ends_at' => $sale->ends_at->format('Y-m-d\TH:i'),
            'is_active' => $sale->is_active,
        ];
        $this->showForm = true;
    }

    public function save(): void
    {
        $this->authorizePermission($this->editingId ? 'flash_sales.update' : 'flash_sales.create');
        $this->validate();

        $data = [
            'title' => $this->form['title'],
            'discount_percent' => (float) $this->form['discount_percent'],
            'starts_at' => $this->form['starts_at'],
            'ends_at' => $this->form['ends_at'],
            'is_active' => (bool) $this->form['is_active'],
        ];

        $sale = $this->editingId ? FlashSale::findOrFail($this->editingId) : new FlashSale();
        $sale->fill($data)->save();
        $sale->products()->sync($this->productIds);

        $this->showForm = false;
        $this->editingId = null;
        $this->productIds = [];
        $this->productSearch = '';
        $this->dispatch('toast', icon: 'success', title: __('messages.success'));
    }

    public function addProduct(int $productId): void
    {
        $this->authorizePermission('flash_sales.update');
        if (!in_array($productId, $this->productIds, true)) {
            $this->productIds[] = $productId;
        }
        $this->productSearch = '';
    }

    public function removeProduct(int $productId): void
    {
        $this->authorizePermission('flash_sales.update');
        $this->productIds = array_values(array_filter($this->productIds, fn($id) => $id !== $productId));
    }

    public function confirmDelete(int $id): void
    {
        $this->authorizePermission('flash_sales.delete');
        $this->dispatch('confirm-delete', id: $id);
    }

    #[On('delete-confirmed')]
    public function delete(int $id): void
    {
        $this->authorizePermission('flash_sales.delete');
        FlashSale::findOrFail($id)->delete();
        $this->dispatch('toast', icon: 'success', title: __('messages.deleted'));
    }

    #[Layout('components.admin.layout', ['title' => 'Flash Sales'])]
    public function render(): View
    {
        $this->authorizePermission('flash_sales.view');
        // Live search for the product picker
        $searchResults = collect();
        if (mb_strlen(trim($this->productSearch)) >= 2) {
            $searchResults = Product::active()
                ->where(function ($q) {
                    $term = $this->productSearch;
                    $q->whereHas('translations', fn($qb) => $qb->where('name', 'like', "%{$term}%"))
                        ->orWhere('sku', 'like', "%{$term}%");
                })
                ->with('brand')
                ->limit(10)
                ->get();
        }

        // Products already in the sale
        $selectedProducts = $this->productIds
            ? Product::whereIn('id', $this->productIds)->with('brand')->get()
            : collect();

        $items = FlashSale::query()
            ->when($this->search, fn($q) => $q->where('title', 'like', "%{$this->search}%"))
            ->withCount('products')
            ->orderBy($this->sortBy, $this->sortDir)
            ->paginate(15);

        return view(
            'livewire.admin.flash-sales.flash-sale-manager',
            compact('items', 'searchResults', 'selectedProducts')
        );
    }
}
