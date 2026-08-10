<?php

namespace App\Livewire\Admin\Customers;

use App\Livewire\Concerns\WithCrudList;
use App\Models\AuditLog;
use App\Models\Customer;
use App\Traits\LogsAdminActions;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;

class CustomerManager extends Component
{
    use WithCrudList, LogsAdminActions;

    public ?int $viewingId = null;

    public function view(int $id): void
    {
        $this->viewingId = $id;
    }

    public function close(): void
    {
        $this->viewingId = null;
    }

    public function toggleActive(int $id): void
    {
        $c = Customer::findOrFail($id);
        $c->is_active = !$c->is_active;
        $c->save();
        $this->dispatch('toast', icon: 'success', title: __('messages.success'));
    }

    public function toggleBanned(int $id): void
    {
        $c = Customer::findOrFail($id);
        $wasBanned = $c->is_banned;
        $c->is_banned = !$c->is_banned;
        $c->save();
        if ($c->is_banned) {
            $this->logAction('customer.banned', $c, ['is_banned' => $wasBanned], ['is_banned' => $c->is_banned]);
        } else {
            $this->logAction('customer.unbanned', $c, ['is_banned' => $wasBanned], ['is_banned' => $c->is_banned]);
        }
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

        $viewing = $this->viewingId
            ? Customer::with([
                'orders' => fn($q) => $q->latest()->limit(10),
                'bookings' => fn($q) => $q->with('service')->latest()->limit(5),
            ])
                ->withCount('orders as total_orders')
                ->withSum('orders as total_spent', 'total')
                ->find($this->viewingId)
            : null;

        $auditLogs = collect();
        if ($viewing) {
            $orderIds = $viewing->orders->pluck('id');
            $bookingIds = $viewing->bookings->pluck('id');

            $auditLogs = AuditLog::query()
                ->with('admin')
                ->where(function ($q) use ($orderIds, $bookingIds) {
                    $q->where(fn($w) => $w->where('subject_type', \App\Models\Order::class)->whereIn('subject_id', $orderIds))
                        ->orWhere(fn($w) => $w->where('subject_type', \App\Models\Booking::class)->whereIn('subject_id', $bookingIds))
                        ->orWhere(fn($w) => $w->where('subject_type', Customer::class)->where('subject_id', $viewing->id));
                })
                ->latest()
                ->limit(50)
                ->get();
        }

        return view('livewire.admin.customers.customer-manager', compact('items', 'viewing', 'auditLogs'));
    }
}
