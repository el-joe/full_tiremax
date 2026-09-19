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

    #[Url]
    public string $statusFilter = '';

    #[Url]
    public string $entityTypeFilter = '';

    #[Layout('components.admin.layout', ['title' => 'Daftra Sync Logs'])]
    public function render()
    {
        $this->authorizePermission('daftra_logs.view');
        $items = DaftraSyncLog::query()
            ->when($this->statusFilter, fn($q) => $q->where('status', $this->statusFilter))
            ->when($this->entityTypeFilter, fn($q) => $q->where('syncable_type', $this->entityTypeFilter))
            ->orderByDesc('created_at')
            ->paginate(20);

        $entityTypes = DaftraSyncLog::query()
            ->whereNotNull('syncable_type')
            ->distinct()
            ->pluck('syncable_type');

        return view('livewire.admin.daftra-logs.daftra-log-manager', compact('items', 'entityTypes'));
    }
}
