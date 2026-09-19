<?php

namespace App\Livewire\Admin\Services;

use App\Livewire\Concerns\WithCrudList;
use App\Models\Service;
use Illuminate\Support\Str;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;
use Livewire\WithFileUploads;

class ServiceManager extends Component
{
    use \App\Livewire\Concerns\AuthorizesAdmin;

    use WithCrudList, WithFileUploads;

    public bool $showForm = false;
    public array $form = [
        'slug' => '',
        'icon' => '',
        'duration_minutes' => 30,
        'price' => 0,
        'is_active' => true,
        'sort_order' => 0,
        'translations' => ['ar' => ['name' => '', 'description' => ''], 'en' => ['name' => '', 'description' => '']],
    ];

    /** @var \Livewire\Features\SupportFileUploads\TemporaryUploadedFile|null */
    public $imageFile = null;
    public ?string $existingImage = null;

    protected function rules(): array
    {
        return [
            'form.translations.ar.name' => ['required', 'string'],
            'form.translations.en.name' => ['required', 'string'],
            'form.duration_minutes' => ['integer', 'min:5', 'max:480'],
            'form.price' => ['numeric', 'min:0'],
            'imageFile' => ['nullable', 'image', 'max:2048'],
        ];
    }

    public function openCreate(): void
    {
        $this->authorizePermission('services.create');
        $this->reset('form', 'editingId', 'imageFile', 'existingImage');
        $this->form['translations'] = ['ar' => ['name' => '', 'description' => ''], 'en' => ['name' => '', 'description' => '']];
        $this->form['is_active'] = true;
        $this->form['duration_minutes'] = 30;
        $this->showForm = true;
    }

    public function edit(int $id): void
    {
        $this->authorizePermission('services.update');
        $s = Service::findOrFail($id);
        $this->editingId = $id;
        $this->existingImage = $s->image;
        $this->imageFile = null;
        $this->form = [
            'slug' => $s->slug,
            'icon' => $s->icon,
            'duration_minutes' => $s->duration_minutes,
            'price' => (float) $s->price,
            'is_active' => $s->is_active,
            'sort_order' => $s->sort_order,
            'translations' => [
                'ar' => ['name' => optional($s->translate('ar'))->name ?? '', 'description' => optional($s->translate('ar'))->description ?? ''],
                'en' => ['name' => optional($s->translate('en'))->name ?? '', 'description' => optional($s->translate('en'))->description ?? ''],
            ],
        ];
        $this->showForm = true;
    }

    public function save(): void
    {
        $this->authorizePermission($this->editingId ? 'services.update' : 'services.create');
        $this->validate();

        $s = $this->editingId ? Service::findOrFail($this->editingId) : new Service();

        $imagePath = $s->image ?? null;
        if ($this->imageFile) {
            $imagePath = $this->imageFile->store('services', 'public');
        }

        $s->fill([
            'slug' => $this->form['slug'] ?: Str::slug($this->form['translations']['en']['name']),
            'icon' => $this->form['icon'],
            'image' => $imagePath,
            'duration_minutes' => (int) $this->form['duration_minutes'],
            'price' => (float) $this->form['price'],
            'is_active' => (bool) $this->form['is_active'],
            'sort_order' => (int) $this->form['sort_order'],
        ])->save();

        foreach ($this->form['translations'] as $locale => $tr) {
            $s->translateOrNew($locale)->fill($tr);
        }
        $s->save();

        $this->showForm = false;
        $this->editingId = null;
        $this->imageFile = null;
        $this->existingImage = null;
        $this->dispatch('toast', icon: 'success', title: __('messages.success'));
    }

    public function removeImage(): void
    {
        $this->authorizePermission('services.update');
        $this->existingImage = null;
        if ($this->editingId) {
            Service::findOrFail($this->editingId)->update(['image' => null]);
        }
    }

    public function confirmDelete(int $id): void
    {
        $this->authorizePermission('services.delete');
        $this->dispatch('confirm-delete', id: $id);
    }

    #[On('delete-confirmed')]
    public function delete(int $id): void
    {
        $this->authorizePermission('services.delete');
        Service::findOrFail($id)->delete();
        $this->dispatch('toast', icon: 'success', title: __('messages.deleted'));
    }

    #[Layout('components.admin.layout', ['title' => 'Services'])]
    public function render()
    {
        $this->authorizePermission('services.view');
        $items = Service::query()
            ->when($this->search, fn($q) => $q->whereHas('translations', fn($qb) => $qb->where('name', 'like', "%{$this->search}%")))
            ->orderBy($this->sortBy, $this->sortDir)
            ->paginate(15);

        return view('livewire.admin.services.service-manager', compact('items'));
    }
}
