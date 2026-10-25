<?php

namespace App\Livewire\Admin\WhatsappTemplates;

use App\Models\WhatsappTemplate;
use Livewire\Attributes\Layout;
use Livewire\Component;

class WhatsappTemplateManager extends Component
{
    use \App\Livewire\Concerns\AuthorizesAdmin;

    public array $form = [];

    public function mount(): void
    {
        $this->authorizePermission('whatsapp.view');
        $this->loadForm();
    }

    protected function loadForm(): void
    {
        $templates = WhatsappTemplate::with('translations')->orderBy('key')->get();

        foreach ($templates as $template) {
            $this->form[$template->id] = [
                'is_active' => $template->is_active,
                'trigger_after_days' => $template->trigger_after_days,
                'subject_ar' => optional($template->translate('ar'))->subject ?? '',
                'subject_en' => optional($template->translate('en'))->subject ?? '',
                'body_ar' => optional($template->translate('ar'))->body ?? '',
                'body_en' => optional($template->translate('en'))->body ?? '',
            ];
        }
    }

    public function save(int $id): void
    {
        $this->authorizePermission('whatsapp.update');
        $template = WhatsappTemplate::with('translations')->findOrFail($id);
        $data = $this->form[$id];

        $this->validate([
            "form.{$id}.trigger_after_days" => ['nullable', 'integer', 'min:1', 'max:3650'],
            "form.{$id}.body_ar" => ['required', 'string'],
            "form.{$id}.body_en" => ['required', 'string'],
        ]);

        $template->update([
            'is_active' => (bool) $data['is_active'],
            // only follow-up templates carry a delay; event-based ones stay null
            'trigger_after_days' => $template->trigger_after_days === null ? null : ($data['trigger_after_days'] ?: $template->trigger_after_days),
        ]);
        $template->translateOrNew('ar')->fill(['subject' => $data['subject_ar'], 'body' => $data['body_ar']]);
        $template->translateOrNew('en')->fill(['subject' => $data['subject_en'], 'body' => $data['body_en']]);
        $template->save();

        $this->dispatch('toast', icon: 'success', title: __('messages.admin.save'));
    }

    #[Layout('components.admin.layout', ['title' => 'WhatsApp Templates'])]
    public function render()
    {
        $this->authorizePermission('whatsapp.view');
        $templates = WhatsappTemplate::with('translations')->orderBy('key')->get();

        return view('livewire.admin.whatsapp-templates.whatsapp-template-manager', compact('templates'));
    }
}
