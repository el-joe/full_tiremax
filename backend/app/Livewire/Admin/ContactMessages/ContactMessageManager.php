<?php

namespace App\Livewire\Admin\ContactMessages;

use App\Livewire\Concerns\WithCrudList;
use App\Models\ContactMessage;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Attributes\Url;
use Livewire\Component;

class ContactMessageManager extends Component
{
    use \App\Livewire\Concerns\AuthorizesAdmin;

    use WithCrudList;

    #[Url(as: 'status', keep: false)]
    public string $status = '';

    public ?int $viewingId = null;
    public string $adminNotes = '';

    protected array $filterKeys = ['status'];
    protected array $sortable = ['id', 'name', 'status', 'created_at'];

    /** Open the detail modal; marks a new message as read. */
    public function view(int $id): void
    {
        $this->authorizePermission('contact_messages.view');
        $message = ContactMessage::findOrFail($id);

        if ($message->status === ContactMessage::STATUS_NEW && auth('admin')->user()?->can('contact_messages.manage')) {
            $message->update(['status' => ContactMessage::STATUS_READ]);
        }

        $this->viewingId = $message->id;
        $this->adminNotes = (string) $message->admin_notes;
    }

    public function closeView(): void
    {
        $this->viewingId = null;
        $this->adminNotes = '';
    }

    public function setStatus(int $id, string $status): void
    {
        $this->authorizePermission('contact_messages.manage');
        if (! in_array($status, ContactMessage::STATUSES, true)) {
            return;
        }
        ContactMessage::findOrFail($id)->update(['status' => $status]);
        $this->toast(__('messages.updated'));
    }

    public function saveNotes(): void
    {
        $this->authorizePermission('contact_messages.manage');
        $this->validate(['adminNotes' => ['nullable', 'string', 'max:5000']]);
        ContactMessage::findOrFail($this->viewingId)->update(['admin_notes' => $this->adminNotes !== '' ? $this->adminNotes : null]);
        $this->toast(__('messages.updated'));
    }

    public function confirmDelete(int $id): void
    {
        $this->authorizePermission('contact_messages.delete');
        $this->dispatch('confirm-delete', id: $id);
    }

    #[On('delete-confirmed')]
    public function delete(int $id): void
    {
        $this->authorizePermission('contact_messages.delete');
        ContactMessage::findOrFail($id)->delete();
        if ($this->viewingId === $id) {
            $this->closeView();
        }
        $this->toast(__('messages.deleted'));
    }

    #[Layout('components.admin.layout', ['title' => 'Contact Messages'])]
    public function render()
    {
        $this->authorizePermission('contact_messages.view');
        $messages = ContactMessage::query()
            ->with('customer')
            ->when(in_array($this->status, ContactMessage::STATUSES, true), fn ($q) => $q->where('status', $this->status))
            ->when($this->search !== '', fn ($q) => $q->where(fn ($qb) => $qb
                ->where('name', 'like', "%{$this->search}%")
                ->orWhere('phone', 'like', "%{$this->search}%")
                ->orWhere('subject', 'like', "%{$this->search}%")))
            ->tap(fn ($q) => $this->applySort($q))
            ->paginate($this->pageSize());

        $viewing = $this->viewingId ? ContactMessage::with('customer')->find($this->viewingId) : null;

        return view('livewire.admin.contact-messages.contact-message-manager', compact('messages', 'viewing'));
    }
}
