<?php

namespace App\Livewire\Admin\Orders;

use App\Livewire\Concerns\WithCrudList;
use App\Models\Order;
use App\Services\DaftraOrderSyncService;
use App\Services\OrderService;
use App\Traits\LogsAdminActions;
use Throwable;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Attributes\Url;
use Livewire\Component;

class OrderManager extends Component
{
    use WithCrudList, LogsAdminActions;

    #[Url]
    public string $statusFilter = '';

    public ?int $viewingId = null;

    public function view(int $id): void
    {
        $this->viewingId = $id;
    }

    public function close(): void
    {
        $this->viewingId = null;
    }

    public function changeStatus(int $id, string $status, OrderService $service): void
    {
        $order = Order::findOrFail($id);
        $oldStatus = $order->status;
        $service->changeStatus($order, $status);
        $this->logAction('order.status_changed', $order, ['status' => $oldStatus], ['status' => $status]);
        $this->dispatch('toast', icon: 'success', title: __('messages.success'));
    }

    public function syncToDaftra(int $id): void
    {
        $order = Order::findOrFail($id);

        try {
            app(DaftraOrderSyncService::class)->push($order);
            $this->dispatch('toast', icon: 'success', title: __('messages.success'));
        } catch (Throwable $e) {
            $this->dispatch('toast', icon: 'error', title: $e->getMessage());
        }
    }

    public function confirmDelete(int $id): void
    {
        $this->dispatch('confirm-delete', id: $id);
    }
    #[On('delete-confirmed')]
    public function delete(int $id): void
    {
        Order::findOrFail($id)->delete();
        $this->dispatch('toast', icon: 'success', title: __('messages.deleted'));
    }

    #[Layout('components.admin.layout', ['title' => 'Orders'])]
    public function render()
    {
        $items = Order::query()
            ->with(['customer', 'governorate', 'branch'])
            ->when($this->statusFilter, fn($q) => $q->where('status', $this->statusFilter))
            ->when($this->search, fn($q) => $q->where(function ($w) {
                $w->where('reference', 'like', "%{$this->search}%")
                    ->orWhere('customer_phone', 'like', "%{$this->search}%")
                    ->orWhere('customer_name', 'like', "%{$this->search}%");
            }))
            ->orderBy($this->sortBy, $this->sortDir)
            ->paginate(20);

        $viewing = $this->viewingId ? Order::with(['items.product', 'statusLogs', 'customer', 'governorate', 'branch'])->find($this->viewingId) : null;

        $statuses = [
            Order::STATUS_PENDING,
            Order::STATUS_CONFIRMED,
            Order::STATUS_PROCESSING,
            Order::STATUS_SHIPPED,
            Order::STATUS_DELIVERED,
            Order::STATUS_COMPLETED,
            Order::STATUS_CANCELLED,
            Order::STATUS_REFUNDED,
        ];

        return view('livewire.admin.orders.order-manager', compact('items', 'viewing', 'statuses'));
    }
}
