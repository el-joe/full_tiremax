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
                'body_ar' => optional($template->translate('ar'))->body ?? '',
                'body_en' => optional($template->translate('en'))->body ?? '',
            ];
        }
    }

    public function save(int $id): void
    {
        $this->authorizePermission('whatsapp.update');
        $template = WhatsappTemplate::findOrFail($id);
        $data = $this->form[$id];

        $template->update(['is_active' => (bool) $data['is_active']]);
        $template->translateOrNew('ar')->fill(['body' => $data['body_ar']]);
        $template->translateOrNew('en')->fill(['body' => $data['body_en']]);
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
