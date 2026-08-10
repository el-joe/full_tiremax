<?php

namespace App\Livewire\Admin\Settings;

use App\Models\Setting;
use Livewire\Attributes\Layout;
use Livewire\Component;

class SettingManager extends Component
{
    public array $form = [];

    public function mount(): void
    {
        $this->loadForm();
    }

    protected function loadForm(): void
    {
        $settings = Setting::with('translations')->orderBy('group')->orderBy('key')->get();

        foreach ($settings as $setting) {
            $this->form[$setting->id] = [
                'value' => $setting->value,
                'ar' => optional($setting->translate('ar'))->value ?? '',
                'en' => optional($setting->translate('en'))->value ?? '',
            ];
        }
    }

    public function save(int $id): void
    {
        $setting = Setting::findOrFail($id);
        $data = $this->form[$id];

        if ($setting->is_translatable) {
            $setting->translateOrNew('ar')->fill(['value' => $data['ar']]);
            $setting->translateOrNew('en')->fill(['value' => $data['en']]);
            $setting->save();
        } else {
            $value = $setting->cast === 'bool' ? (($data['value'] ?? false) ? '1' : '0') : $data['value'];
            $setting->update(['value' => $value]);
        }

        $this->dispatch('toast', icon: 'success', title: __('messages.admin.save'));
    }

    #[Layout('components.admin.layout', ['title' => 'Settings'])]
    public function render()
    {
        $settings = Setting::with('translations')->orderBy('group')->orderBy('key')->get();

        return view('livewire.admin.settings.setting-manager', compact('settings'));
    }
}
