<?php

namespace App\Livewire\Admin\Customers;

use App\Livewire\Concerns\WithCrudList;
use App\Models\Customer;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;

class CustomerManager extends Component
{
    use WithCrudList;

    public function toggleActive(int $id): void
    {
        $c = Customer::findOrFail($id);
        $c->is_active = !$c->is_active;
        $c->save();
        $this->dispatch('toast', icon: 'success', title: __('messages.success'));
    }

    public function confirmDelete(int $id): void
    {
        $this->dispatch('confirm-delete', id: $id);
    }
    #[On('delete-confirmed')]
    public function delete(int $id): void
    {
        Customer::findOrFail($id)->delete();
        $this->dispatch('toast', icon: 'success', title: __('messages.deleted'));
    }

    #[Layout('components.admin.layout', ['title' => 'Customers'])]
    public function render()
    {
        $items = Customer::query()
            ->withCount(['orders', 'bookings'])
            ->when($this->search, fn($q) => $q->where('name', 'like', "%{$this->search}%")
                ->orWhere('phone', 'like', "%{$this->search}%")
                ->orWhere('email', 'like', "%{$this->search}%"))
            ->orderBy($this->sortBy, $this->sortDir)
            ->paginate(20);
        return view('livewire.admin.customers.customer-manager', compact('items'));
    }
}
