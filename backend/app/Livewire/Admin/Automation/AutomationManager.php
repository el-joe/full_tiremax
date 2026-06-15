<?php

namespace App\Livewire\Admin\Automation;

use App\Jobs\SendWhatsappMessage;
use App\Models\Customer;
use App\Models\Order;
use App\Models\WhatsappLog;
use App\Models\WhatsappTemplate;
use Livewire\Attributes\Layout;
use Livewire\Attributes\Url;
use Livewire\Component;
use Livewire\WithPagination;

class AutomationManager extends Component
{
    use WithPagination;

    #[Url]
    public string $tab = 'templates'; // templates | logs

    #[Url]
    public string $logStatus = '';

    #[Url]
    public string $search = '';

    // Template editing
    public ?int $editingTemplateId = null;
    public bool $showTemplateModal = false;
    public string $editKey = '';
    public ?int $editTriggerDays = null;
    public bool $editIsActive = true;
    public string $editBodyAr = '';
    public string $editBodyEn = '';
    public string $editSubjectAr = '';
    public string $editSubjectEn = '';

    public function switchTab(string $tab): void
    {
        $this->tab = $tab;
        $this->resetPage();
    }

    public function editTemplate(int $id): void
    {
        $template = WhatsappTemplate::with('translations')->findOrFail($id);

        $this->editingTemplateId = $id;
        $this->editKey           = $template->key;
        $this->editTriggerDays   = $template->trigger_after_days;
        $this->editIsActive      = $template->is_active;

        $ar = $template->translations->firstWhere('locale', 'ar');
        $en = $template->translations->firstWhere('locale', 'en');

        $this->editBodyAr    = $ar?->body ?? '';
        $this->editBodyEn    = $en?->body ?? '';
        $this->editSubjectAr = $ar?->subject ?? '';
        $this->editSubjectEn = $en?->subject ?? '';

        $this->showTemplateModal = true;
    }

    public function saveTemplate(): void
    {
        $this->validate([
            'editBodyAr' => 'required|string',
            'editBodyEn' => 'required|string',
        ]);

        $template = WhatsappTemplate::findOrFail($this->editingTemplateId);

        $template->update([
            'trigger_after_days' => $this->editTriggerDays,
            'is_active'          => $this->editIsActive,
        ]);

        $template->translations()->updateOrCreate(
            ['locale' => 'ar'],
            ['body' => $this->editBodyAr, 'subject' => $this->editSubjectAr]
        );
        $template->translations()->updateOrCreate(
            ['locale' => 'en'],
            ['body' => $this->editBodyEn, 'subject' => $this->editSubjectEn]
        );

        $this->showTemplateModal = false;
        $this->dispatch('toast', icon: 'success', title: 'Template saved');
    }

    public function toggleTemplate(int $id): void
    {
        $template = WhatsappTemplate::findOrFail($id);
        $template->update(['is_active' => !$template->is_active]);
        $this->dispatch('toast', icon: 'success', title: 'Updated');
    }

    public function resendLog(int $id): void
    {
        $log      = WhatsappLog::with(['customer', 'order', 'template'])->findOrFail($id);
        $template = $log->template;
        $customer = $log->customer;

        if (!$template || !$customer) return;

        SendWhatsappMessage::dispatch($template, $customer, $log->order);
        $this->dispatch('toast', icon: 'success', title: 'Queued for resend');
    }

    #[Layout('components.admin.layout', ['title' => 'Automation'])]
    public function render()
    {
        $templates = WhatsappTemplate::with('translations')
            ->orderByRaw('ISNULL(trigger_after_days), trigger_after_days')
            ->get();

        $logs = WhatsappLog::with(['customer', 'order', 'template'])
            ->when($this->logStatus, fn($q) => $q->where('status', $this->logStatus))
            ->when($this->search, fn($q) => $q->where('phone', 'like', "%{$this->search}%"))
            ->latest()
            ->paginate(20);

        return view('livewire.admin.automation.automation-manager', compact('templates', 'logs'));
    }
}
