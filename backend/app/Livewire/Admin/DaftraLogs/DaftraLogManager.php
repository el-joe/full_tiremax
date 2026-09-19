<?php

namespace App\Livewire\Admin\DaftraLogs;

use App\Livewire\Concerns\WithCrudList;
use App\Models\DaftraSyncLog;
use Livewire\Attributes\Layout;
use Livewire\Attributes\Url;
use Livewire\Component;

class DaftraLogManager extends Component
{
    use \App\Livewire\Concerns\AuthorizesAdmin;

    use WithCrudList;

    #[Url(as: 'status', keep: false)]
    public string $statusFilter = '';
    #[Url(as: 'entity', keep: false)]
    public string $entityTypeFilter = '';
    #[Url(as: 'action', keep: false)]
    public string $actionFilter = '';
    #[Url(as: 'from', keep: false)]
    public string $from = '';
    #[Url(as: 'to', keep: false)]
    public string $to = '';

    protected array $filterKeys = ['statusFilter', 'entityTypeFilter', 'actionFilter', 'from', 'to'];
    protected array $sortable = ['created_at', 'id', 'status'];

    #[Layout('components.admin.layout', ['title' => 'Daftra Sync Logs'])]
    public function render()
    {
        $this->authorizePermission('daftra_logs.view');
        $items = DaftraSyncLog::query()
            ->when($this->statusFilter !== '', fn ($q) => $q->where('status', $this->statusFilter))
            ->when($this->entityTypeFilter !== '', fn ($q) => $q->where('syncable_type', $this->entityTypeFilter))
            ->when($this->actionFilter !== '', fn ($q) => $q->where('action', $this->actionFilter))
            ->when($this->from !== '', fn ($q) => $q->whereDate('created_at', '>=', $this->from))
            ->when($this->to !== '', fn ($q) => $q->whereDate('created_at', '<=', $this->to))
            ->when($this->search !== '', fn ($q) => $q->where(fn ($w) => $w
                ->where('syncable_id', $this->search)->orWhere('order_id', $this->search)
                ->orWhere('response', 'like', "%{$this->search}%")))
            ->tap(fn ($q) => $this->applySort($q, 'created_at'))
            ->paginate($this->pageSize());

        $entityTypes = DaftraSyncLog::query()
            ->whereNotNull('syncable_type')
            ->distinct()
            ->pluck('syncable_type');

        return view('livewire.admin.daftra-logs.daftra-log-manager', compact('items', 'entityTypes') + ['actions' => DaftraSyncLog::query()->distinct()->orderBy('action')->pluck('action')]);
    }
}
