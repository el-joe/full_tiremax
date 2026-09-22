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
    use \App\Livewire\Concerns\AuthorizesAdmin;

    use WithCrudList, LogsAdminActions;

    #[Url(as: 'status', keep: false)]
    public string $statusFilter = '';
    #[Url(as: 'type', keep: false)]
    public string $typeFilter = '';
    #[Url(as: 'payment_method', keep: false)]
    public string $paymentMethod = '';
    #[Url(as: 'payment_status', keep: false)]
    public string $paymentStatus = '';
    #[Url(as: 'branch', keep: false)]
    public ?int $branchFilter = null;
    #[Url(as: 'governorate', keep: false)]
    public ?int $governorateFilter = null;
    #[Url(as: 'kind', keep: false)]
    public string $customerKind = '';
    #[Url(as: 'from', keep: false)]
    public string $from = '';
    #[Url(as: 'to', keep: false)]
    public string $to = '';
    #[Url(as: 'total_min', keep: false)]
    public string $totalMin = '';
    #[Url(as: 'total_max', keep: false)]
    public string $totalMax = '';

    protected array $filterKeys = ['statusFilter', 'typeFilter', 'paymentMethod', 'paymentStatus', 'branchFilter', 'governorateFilter', 'customerKind', 'from', 'to', 'totalMin', 'totalMax'];
    protected array $sortable = ['id', 'total', 'status', 'created_at'];



    public ?int $viewingId = null;
    public string $tab = 'details';

    public function view(int $id): void
    {
        $this->authorizePermission('orders.view');
        $this->viewingId = $id;
        $this->tab = 'details';
    }

    public function close(): void
    {
        $this->viewingId = null;
    }

    public function changeStatus(int $id, string $status, OrderService $service): void
    {
        $this->authorizePermission('orders.change_status');
        $order = Order::findOrFail($id);
        $oldStatus = $order->status;
        $service->changeStatus($order, $status);
        $this->logAction('order.status_changed', $order, ['status' => $oldStatus], ['status' => $status]);
        $this->dispatch('toast', icon: 'success', title: __('messages.success'));
    }

    public function resendNotification(string $channel, int $logId): void
    {
        $this->authorizePermission('orders.update');
        $order = Order::findOrFail($this->viewingId);
        $notifier = app(\App\Services\OrderNotifier::class);
        if ($channel === 'email') {
            $log = \App\Models\NotificationLog::where('subject_type', Order::class)->where('subject_id', $order->id)->findOrFail($logId);
            $notifier->resendEmail($log, $order);
        } else {
            $log = \App\Models\WhatsappLog::where('order_id', $order->id)->findOrFail($logId);
            if ($log->template_key && \App\Support\NotificationSettings::whatsappEnabled()) {
                \Illuminate\Support\Facades\Notification::route('whatsapp', $log->phone)
                    ->notify(new \App\Notifications\WhatsappTemplateNotification($log->template_key, $order, $order->customer_locale ?: 'ar', true));
            }
        }
        $this->logAction('order.notification_resent', $order, [], ['channel' => $channel]);
        $this->dispatch('toast', icon: 'success', title: __('messages.success'));
    }

    public function syncToDaftra(int $id): void
    {
        $this->authorizePermission('orders.update');
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
        $this->authorizePermission('orders.delete');
        $this->dispatch('confirm-delete', id: $id);
    }
    #[On('delete-confirmed')]
    public function delete(int $id): void
    {
        $this->authorizePermission('orders.delete');
        Order::findOrFail($id)->delete();
        $this->dispatch('toast', icon: 'success', title: __('messages.deleted'));
    }

    #[Layout('components.admin.layout', ['title' => 'Orders'])]
    public function render()
    {
        $this->authorizePermission('orders.view');
        $items = Order::query()
            ->with(['customer', 'governorate.translations', 'branch.translations'])
            ->when($this->statusFilter !== '', fn ($q) => $q->where('status', $this->statusFilter))
            ->when($this->typeFilter !== '', fn ($q) => $q->where('type', $this->typeFilter))
            ->when($this->paymentMethod !== '', fn ($q) => $q->where('payment_method', $this->paymentMethod))
            ->when($this->paymentStatus !== '', fn ($q) => $q->where('payment_status', $this->paymentStatus))
            ->when($this->branchFilter, fn ($q) => $q->where('branch_id', $this->branchFilter))
            ->when($this->governorateFilter, fn ($q) => $q->where('governorate_id', $this->governorateFilter))
            ->when($this->customerKind === 'registered', fn ($q) => $q->whereNotNull('customer_id')->where('is_guest', false))
            ->when($this->customerKind === 'guest', fn ($q) => $q->where(fn ($g) => $g->whereNull('customer_id')->orWhere('is_guest', true)))
            ->when($this->from !== '', fn ($q) => $q->whereDate('created_at', '>=', $this->from))
            ->when($this->to !== '', fn ($q) => $q->whereDate('created_at', '<=', $this->to))
            ->when(is_numeric($this->totalMin), fn ($q) => $q->where('total', '>=', $this->totalMin))
            ->when(is_numeric($this->totalMax), fn ($q) => $q->where('total', '<=', $this->totalMax))
            ->when($this->search !== '', fn ($q) => $q->where(fn ($w) => $w
                ->where('reference', 'like', "%{$this->search}%")
                ->orWhere('customer_phone', 'like', "%{$this->search}%")
                ->orWhere('customer_name', 'like', "%{$this->search}%")
                ->orWhere('customer_email', 'like', "%{$this->search}%")))
            ->tap(fn ($q) => $this->applySort($q))
            ->paginate($this->pageSize());

        $viewing = $this->viewingId ? Order::with(['items.product.translations', 'statusLogs', 'customer', 'governorate.translations', 'branch.translations'])->find($this->viewingId) : null;

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

        $emailLogs = $viewing && $this->tab === 'notifications'
            ? \App\Models\NotificationLog::where('subject_type', Order::class)->where('subject_id', $viewing->id)->latest()->get() : collect();
        $waLogs = $viewing && $this->tab === 'notifications'
            ? \App\Models\WhatsappLog::with('template')->where('order_id', $viewing->id)->latest()->get() : collect();

        return view('livewire.admin.orders.order-manager', compact('items', 'viewing', 'statuses', 'emailLogs', 'waLogs') + [
            'branches' => \App\Models\Branch::with('translations')->get(),
            'governorates' => \App\Models\Governorate::with('translations')->orderBy('sort_order')->get(),
        ]);
    }
}
