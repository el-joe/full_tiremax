<?php

namespace App\Livewire\Admin\WhatsappLogs;

use App\Livewire\Concerns\AuthorizesAdmin;
use App\Livewire\Concerns\WithCrudList;
use App\Models\WhatsappLog;
use App\Models\WhatsappTemplate;
use Livewire\Attributes\Layout;
use Livewire\Attributes\Url;
use Livewire\Component;

class WhatsappLogManager extends Component
{
    use AuthorizesAdmin, WithCrudList;

    #[Url(as: 'status', keep: false)]
    public string $statusFilter = '';
    #[Url(as: 'template', keep: false)]
    public ?int $templateFilter = null;
    #[Url(as: 'from', keep: false)]
    public string $from = '';
    #[Url(as: 'to', keep: false)]
    public string $to = '';

    protected array $filterKeys = ['statusFilter', 'templateFilter', 'from', 'to'];
    protected array $sortable = ['id', 'created_at', 'status', 'sent_at'];

    #[Layout('components.admin.layout', ['title' => 'WhatsApp Logs'])]
    public function render()
    {
        $this->authorizePermission('whatsapp.view');
        $items = WhatsappLog::query()
            ->with(['customer:id,name,phone', 'template:id,key', 'order:id,reference'])
            ->when($this->statusFilter !== '', fn ($q) => $q->where('status', $this->statusFilter))
            ->when($this->templateFilter, fn ($q) => $q->where('whatsapp_template_id', $this->templateFilter))
            ->when($this->from !== '', fn ($q) => $q->whereDate('created_at', '>=', $this->from))
            ->when($this->to !== '', fn ($q) => $q->whereDate('created_at', '<=', $this->to))
            ->when($this->search !== '', fn ($q) => $q->where(fn ($w) => $w
                ->where('phone', 'like', "%{$this->search}%")
                ->orWhereHas('customer', fn ($c) => $c->where(fn ($cc) => $cc
                    ->where('name', 'like', "%{$this->search}%")
                    ->orWhere('phone', 'like', "%{$this->search}%")))))
            ->tap(fn ($q) => $this->applySort($q))
            ->paginate($this->pageSize());

        return view('livewire.admin.whatsapp-logs.whatsapp-log-manager', [
            'items' => $items,
            'templates' => WhatsappTemplate::orderBy('key')->get(['id', 'key']),
        ]);
    }
}
