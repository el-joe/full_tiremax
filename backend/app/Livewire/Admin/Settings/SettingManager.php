<?php

namespace App\Livewire\Admin\Settings;

use App\Models\Setting;
use Livewire\Attributes\Layout;
use Livewire\Component;
use Livewire\WithFileUploads;

class SettingManager extends Component
{
    use \App\Livewire\Concerns\AuthorizesAdmin;

    use WithFileUploads;

    public array $form = [];

    /** @var array<int, \Livewire\Features\SupportFileUploads\TemporaryUploadedFile|null> */
    public array $imageFiles = [];

    protected function rules(): array
    {
        return [
            'imageFiles.*' => ['nullable', 'image', 'max:2048'],
        ];
    }

    public function mount(): void
    {
        $this->authorizePermission('settings.view');
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
        $this->authorizePermission('settings.update');
        $setting = Setting::with('translations')->findOrFail($id);
        $data = $this->form[$id];

        if ($setting->cast === 'image') {
            $this->validateOnly("imageFiles.{$id}");
        }

        if ($setting->is_translatable) {
            $setting->translateOrNew('ar')->fill(['value' => $data['ar']]);
            $setting->translateOrNew('en')->fill(['value' => $data['en']]);
            $setting->save();
        } elseif ($setting->cast === 'image') {
            $value = $data['value'] ?? null;

            if (!empty($this->imageFiles[$id])) {
                $value = $this->imageFiles[$id]->store('settings', 'public');
            }

            $setting->update(['value' => $value]);
            unset($this->imageFiles[$id]);
        } else {
            $value = $setting->cast === 'bool' ? (($data['value'] ?? false) ? '1' : '0') : $data['value'];
            $setting->update(['value' => $value]);
        }

        \App\Services\PublicSettings::flush();
        $this->loadForm();

        $this->dispatch('toast', icon: 'success', title: __('messages.admin.save'));
    }

    public function removeImage(int $id): void
    {
        $this->authorizePermission('settings.update');
        $setting = Setting::findOrFail($id);
        $setting->update(['value' => null]);
        unset($this->imageFiles[$id]);
        $this->form[$id]['value'] = null;
    }

    #[Layout('components.admin.layout', ['title' => 'Settings'])]
    public function render()
    {
        $this->authorizePermission('settings.view');
        $groups = Setting::with('translations')
            ->orderBy('group')
            ->orderBy('key')
            ->get()
            ->groupBy('group');

        return view('livewire.admin.settings.setting-manager', compact('groups'));
    }
}
