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

    #[Url]
    public string $statusFilter = '';
    #[Url]
    public ?int $branchFilter = null;

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
            ->with(['customer', 'service', 'branch'])
            ->when($this->statusFilter, fn($q) => $q->where('status', $this->statusFilter))
            ->when($this->branchFilter, fn($q) => $q->where('branch_id', $this->branchFilter))
            ->when($this->search, fn($q) => $q->where('reference', 'like', "%{$this->search}%"))
            ->orderBy('scheduled_at', 'desc')
            ->paginate(20);

        $statuses = [
            Booking::STATUS_PENDING,
            Booking::STATUS_CONFIRMED,
            Booking::STATUS_IN_PROGRESS,
            Booking::STATUS_COMPLETED,
            Booking::STATUS_CANCELLED,
            Booking::STATUS_NO_SHOW,
        ];
        $branches = \App\Models\Branch::all();

        return view('livewire.admin.bookings.booking-manager', compact('items', 'statuses', 'branches'));
    }
}
