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
    use WithCrudList;

    #[Url]
    public string $status = 'pending';

    public function updatingStatus(): void
    {
        $this->resetPage();
    }

    public function approve(int $id): void
    {
        Review::findOrFail($id)->update(['is_approved' => true]);
        $this->toast(__('messages.success'));
    }

    public function reject(int $id): void
    {
        Review::findOrFail($id)->update(['is_approved' => false]);
        $this->toast(__('messages.success'));
    }

    public function confirmDelete(int $id): void
    {
        $this->dispatch('confirm-delete', id: $id);
    }

    #[On('delete-confirmed')]
    public function delete(int $id): void
    {
        Review::findOrFail($id)->delete();
        $this->toast(__('messages.deleted'));
    }

    #[Layout('components.admin.layout', ['title' => 'Reviews'])]
    public function render()
    {
        $reviews = Review::query()
            ->with(['customer', 'product'])
            ->when($this->status === 'pending', fn($q) => $q->whereNull('is_approved'))
            ->when($this->status === 'approved', fn($q) => $q->where('is_approved', true))
            ->when($this->status === 'rejected', fn($q) => $q->where('is_approved', false))
            ->when($this->search, fn($q) => $q->where(function ($qb) {
                $qb->whereHas('customer', fn($c) => $c->where('name', 'like', "%{$this->search}%"))
                    ->orWhereHas('product', fn($p) => $p->whereHas('translations', fn($t) => $t->where('name', 'like', "%{$this->search}%")))
                    ->orWhere('comment', 'like', "%{$this->search}%");
            }))
            ->orderBy($this->sortBy, $this->sortDir)
            ->paginate(15);

        return view('livewire.admin.reviews.review-manager', compact('reviews'));
    }
}
