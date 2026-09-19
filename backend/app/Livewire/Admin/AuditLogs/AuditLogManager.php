<?php

namespace App\Livewire\Admin\AuditLogs;

use App\Livewire\Concerns\AuthorizesAdmin;
use App\Livewire\Concerns\WithCrudList;
use App\Models\Admin;
use App\Models\AuditLog;
use Livewire\Attributes\Layout;
use Livewire\Attributes\Url;
use Livewire\Component;

class AuditLogManager extends Component
{
    use AuthorizesAdmin, WithCrudList;

    #[Url]
    public ?int $adminFilter = null;
    #[Url]
    public string $actionFilter = '';
    #[Url]
    public string $subjectFilter = '';
    #[Url]
    public string $from = '';
    #[Url]
    public string $to = '';

    public function updatingAdminFilter(): void { $this->resetPage(); }
    public function updatingActionFilter(): void { $this->resetPage(); }
    public function updatingSubjectFilter(): void { $this->resetPage(); }
    public function updatingFrom(): void { $this->resetPage(); }
    public function updatingTo(): void { $this->resetPage(); }

    #[Layout('components.admin.layout', ['title' => 'Audit Log'])]
    public function render()
    {
        $this->authorizePermission('audit_logs.view');
        $s = $this->search;
        $logs = AuditLog::query()->with('admin')
            ->when($this->adminFilter, fn ($q) => $q->where('admin_id', $this->adminFilter))
            ->when($this->actionFilter !== '', fn ($q) => $q->where('action', $this->actionFilter))
            ->when($this->subjectFilter !== '', fn ($q) => $q->where('subject_type', $this->subjectFilter))
            ->when($this->from !== '', fn ($q) => $q->whereDate('created_at', '>=', $this->from))
            ->when($this->to !== '', fn ($q) => $q->whereDate('created_at', '<=', $this->to))
            ->when($s !== '', fn ($q) => $q->where(fn ($w) => $w
                ->where('action', 'like', "%{$s}%")->orWhere('ip', 'like', "%{$s}%")
                ->orWhere('changes', 'like', "%{$s}%")->orWhere('subject_id', $s)))
            ->orderByDesc('id')
            ->paginate(20);

        return view('livewire.admin.audit-logs.audit-log-manager', [
            'logs' => $logs,
            'admins' => Admin::withTrashed()->orderBy('name')->get(['id', 'name']),
            'actions' => AuditLog::query()->distinct()->orderBy('action')->pluck('action'),
            'subjects' => AuditLog::query()->whereNotNull('subject_type')->distinct()->orderBy('subject_type')->pluck('subject_type'),
        ]);
    }
}
