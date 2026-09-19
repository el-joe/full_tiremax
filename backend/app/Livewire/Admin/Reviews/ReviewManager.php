<?php

namespace App\Livewire\Admin\Reviews;

use App\Livewire\Concerns\WithCrudList;
use App\Models\Review;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Attributes\Url;
use Livewire\Component;

class ReviewManager extends Component
{
    use \App\Livewire\Concerns\AuthorizesAdmin;

    use WithCrudList;

    #[Url(as: 'status', keep: false)]
    public string $status = 'pending';
    #[Url(as: 'rating', keep: false)]
    public string $rating = '';
    #[Url(as: 'type', keep: false)]
    public string $typeFilter = '';
    #[Url(as: 'product', keep: false)]
    public ?int $productFilter = null;

    protected array $filterKeys = ['status', 'rating', 'typeFilter', 'productFilter'];
    protected array $sortable = ['id', 'rating', 'created_at'];



    public function updatingStatus(): void
    {
        $this->resetPage();
    }

    public function approve(int $id): void
    {
        $this->authorizePermission('reviews.moderate');
        Review::findOrFail($id)->update(['is_approved' => true]);
        $this->toast(__('messages.success'));
    }

    public function reject(int $id): void
    {
        $this->authorizePermission('reviews.moderate');
        Review::findOrFail($id)->update(['is_approved' => false]);
        $this->toast(__('messages.success'));
    }

    public function confirmDelete(int $id): void
    {
        $this->authorizePermission('reviews.delete');
        $this->dispatch('confirm-delete', id: $id);
    }

    #[On('delete-confirmed')]
    public function delete(int $id): void
    {
        $this->authorizePermission('reviews.delete');
        Review::findOrFail($id)->delete();
        $this->toast(__('messages.deleted'));
    }

    #[Layout('components.admin.layout', ['title' => 'Reviews'])]
    public function render()
    {
        $this->authorizePermission('reviews.view');
        $reviews = Review::query()
            ->with(['customer', 'product.translations'])
            ->when($this->status === 'pending', fn ($q) => $q->whereNull('is_approved'))
            ->when($this->status === 'approved', fn ($q) => $q->where('is_approved', true))
            ->when($this->status === 'rejected', fn ($q) => $q->where('is_approved', false))
            ->when(is_numeric($this->rating), fn ($q) => $q->where('rating', (int) $this->rating))
            ->when($this->typeFilter !== '', fn ($q) => $q->where('type', $this->typeFilter))
            ->when($this->productFilter, fn ($q) => $q->where('product_id', $this->productFilter))
            ->when($this->search !== '', fn ($q) => $q->where(fn ($qb) => $qb
                ->whereHas('customer', fn ($c) => $c->where('name', 'like', "%{$this->search}%"))
                ->orWhereHas('product', fn ($p) => $p->searchTranslated($this->search, ['name'], ['sku']))
                ->orWhere('comment', 'like', "%{$this->search}%")))
            ->tap(fn ($q) => $this->applySort($q))
            ->paginate($this->pageSize());

        return view('livewire.admin.reviews.review-manager', compact('reviews'));
    }
}
