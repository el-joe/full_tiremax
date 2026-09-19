<?php

namespace App\Livewire\Admin\Bookings;

use App\Livewire\Concerns\WithCrudList;
use App\Models\Booking;
use App\Services\BookingService;
use App\Traits\LogsAdminActions;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Attributes\Url;
use Livewire\Component;

class BookingManager extends Component
{
    use \App\Livewire\Concerns\AuthorizesAdmin;

    use WithCrudList, LogsAdminActions;

    #[Url(as: 'status', keep: false)]
    public string $statusFilter = '';
    #[Url(as: 'branch', keep: false)]
    public ?int $branchFilter = null;
    #[Url(as: 'service', keep: false)]
    public ?int $serviceFilter = null;
    #[Url(as: 'from', keep: false)]
    public string $from = '';
    #[Url(as: 'to', keep: false)]
    public string $to = '';
    #[Url(as: 'quick', keep: false)]
    public string $quick = '';
    #[Url(as: 'kind', keep: false)]
    public string $customerKind = '';

    protected array $filterKeys = ['statusFilter', 'branchFilter', 'serviceFilter', 'from', 'to', 'quick', 'customerKind'];
    protected array $sortable = ['created_at', 'scheduled_at', 'status'];



    public function changeStatus(int $id, string $status, BookingService $service): void
    {
        $this->authorizePermission('bookings.change_status');
        $booking = Booking::findOrFail($id);
        $oldStatus = $booking->status;
        $service->changeStatus($booking, $status);
        $this->logAction('booking.status_changed', $booking, ['status' => $oldStatus], ['status' => $status]);
        $this->dispatch('toast', icon: 'success', title: __('messages.success'));
    }

    public function confirmDelete(int $id): void
    {
        $this->authorizePermission('bookings.delete');
        $this->dispatch('confirm-delete', id: $id);
    }
    #[On('delete-confirmed')]
    public function delete(int $id): void
    {
        $this->authorizePermission('bookings.delete');
        Booking::findOrFail($id)->delete();
        $this->dispatch('toast', icon: 'success', title: __('messages.deleted'));
    }

    #[Layout('components.admin.layout', ['title' => 'Bookings'])]
    public function render()
    {
        $this->authorizePermission('bookings.view');
        $items = Booking::query()
            ->with(['customer', 'service.translations', 'branch.translations'])
            ->when($this->statusFilter !== '', fn ($q) => $q->where('status', $this->statusFilter))
            ->when($this->branchFilter, fn ($q) => $q->where('branch_id', $this->branchFilter))
            ->when($this->serviceFilter, fn ($q) => $q->where('service_id', $this->serviceFilter))
            ->when($this->customerKind === 'registered', fn ($q) => $q->whereNotNull('customer_id')->where('is_guest', false))
            ->when($this->customerKind === 'guest', fn ($q) => $q->where(fn ($g) => $g->whereNull('customer_id')->orWhere('is_guest', true)))
            ->when($this->from !== '', fn ($q) => $q->whereDate('scheduled_at', '>=', $this->from))
            ->when($this->to !== '', fn ($q) => $q->whereDate('scheduled_at', '<=', $this->to))
            ->when($this->quick === 'today', fn ($q) => $q->whereDate('scheduled_at', today()))
            ->when($this->quick === 'tomorrow', fn ($q) => $q->whereDate('scheduled_at', today()->addDay()))
            ->when($this->quick === 'week', fn ($q) => $q->whereBetween('scheduled_at', [now()->startOfWeek(), now()->endOfWeek()]))
            ->when($this->search !== '', fn ($q) => $q->where(fn ($w) => $w
                ->where('reference', 'like', "%{$this->search}%")
                ->orWhere('customer_name', 'like', "%{$this->search}%")
                ->orWhere('customer_phone', 'like', "%{$this->search}%")
                ->orWhere('customer_email', 'like', "%{$this->search}%")
                ->orWhereHas('customer', fn ($c) => $c->where(fn ($cc) => $cc
                    ->where('name', 'like', "%{$this->search}%")
                    ->orWhere('phone', 'like', "%{$this->search}%")))))
            ->tap(fn ($q) => $this->applySort($q, 'scheduled_at'))
            ->paginate($this->pageSize());

        $statuses = [
            Booking::STATUS_PENDING,
            Booking::STATUS_CONFIRMED,
            Booking::STATUS_IN_PROGRESS,
            Booking::STATUS_COMPLETED,
            Booking::STATUS_CANCELLED,
            Booking::STATUS_NO_SHOW,
        ];
        $branches = \App\Models\Branch::with("translations")->get();

        return view('livewire.admin.bookings.booking-manager', compact('items', 'statuses', 'branches') + ['services' => \App\Models\Service::with('translations')->get()]);
    }
}
