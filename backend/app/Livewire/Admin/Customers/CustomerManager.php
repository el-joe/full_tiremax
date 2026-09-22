<?php

namespace App\Livewire\Admin\Customers;

use Livewire\Attributes\Url;
use App\Livewire\Concerns\WithCrudList;
use App\Models\AuditLog;
use App\Models\Customer;
use App\Traits\LogsAdminActions;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;

class CustomerManager extends Component
{
    use \App\Livewire\Concerns\AuthorizesAdmin;

    use WithCrudList, LogsAdminActions;

    #[Url(as: 'status', keep: false)]
    public string $statusFilter = '';
    #[Url(as: 'has_orders', keep: false)]
    public string $hasOrders = '';
    #[Url(as: 'from', keep: false)]
    public string $registeredFrom = '';
    #[Url(as: 'to', keep: false)]
    public string $registeredTo = '';
    #[Url(as: 'locale', keep: false)]
    public string $localeFilter = '';

    protected array $filterKeys = ['statusFilter', 'hasOrders', 'registeredFrom', 'registeredTo', 'localeFilter'];
    protected array $sortable = ['id', 'name', 'created_at', 'orders_count'];


    public ?int $viewingId = null;

    public function view(int $id): void
    {
        $this->authorizePermission('customers.view');
        $this->viewingId = $id;
    }

    public function close(): void
    {
        $this->viewingId = null;
    }

    public function toggleActive(int $id): void
    {
        $this->authorizePermission('customers.update');
        $c = Customer::findOrFail($id);
        $c->is_active = !$c->is_active;
        $c->save();
        $this->dispatch('toast', icon: 'success', title: __('messages.success'));
    }

    public function toggleBanned(int $id): void
    {
        $this->authorizePermission('customers.ban');
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

    public function linkGuestOrders(int $id): void
    {
        $this->authorizePermission('customers.update');
        $c = Customer::findOrFail($id);
        $linked = app(\App\Services\GuestLinkService::class)->attach($c);
        $this->logAction('customer.guest_linked', $c, [], $linked);
        $this->dispatch('toast', icon: 'success', title: __('messages.success') . " ({$linked['orders']} orders, {$linked['bookings']} bookings)");
    }

    public function confirmDelete(int $id): void
    {
        $this->authorizePermission('customers.delete');
        $this->dispatch('confirm-delete', id: $id);
    }
    #[On('delete-confirmed')]
    public function delete(int $id): void
    {
        $this->authorizePermission('customers.delete');
        Customer::findOrFail($id)->delete();
        $this->dispatch('toast', icon: 'success', title: __('messages.deleted'));
    }

    #[Layout('components.admin.layout', ['title' => 'Customers'])]
    public function render()
    {
        $this->authorizePermission('customers.view');
        $items = Customer::query()
            ->withCount(['orders', 'bookings'])
            ->when($this->search !== '', fn ($q) => $q->where(fn ($w) => $w
                ->where('name', 'like', "%{$this->search}%")
                ->orWhere('phone', 'like', "%{$this->search}%")
                ->orWhere('email', 'like', "%{$this->search}%")))
            ->when($this->statusFilter === 'active', fn ($q) => $q->where('is_active', true)->where('is_banned', false))
            ->when($this->statusFilter === 'inactive', fn ($q) => $q->where('is_active', false))
            ->when($this->statusFilter === 'banned', fn ($q) => $q->where('is_banned', true))
            ->when($this->hasOrders === 'yes', fn ($q) => $q->has('orders'))
            ->when($this->hasOrders === 'no', fn ($q) => $q->doesntHave('orders'))
            ->when($this->registeredFrom !== '', fn ($q) => $q->whereDate('created_at', '>=', $this->registeredFrom))
            ->when($this->registeredTo !== '', fn ($q) => $q->whereDate('created_at', '<=', $this->registeredTo))
            ->when($this->localeFilter !== '', fn ($q) => $q->where('locale', $this->localeFilter))
            ->tap(fn ($q) => $this->applySort($q))
            ->paginate($this->pageSize());

        $viewing = $this->viewingId
            ? Customer::with([
                'orders' => fn($q) => $q->latest()->limit(10),
                'bookings' => fn($q) => $q->with('service.translations')->latest()->limit(5),
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
