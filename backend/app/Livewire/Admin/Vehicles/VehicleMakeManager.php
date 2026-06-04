<?php

namespace App\Livewire\Admin\Vehicles;

use App\Livewire\Concerns\WithCrudList;
use App\Models\VehicleMake;
use Illuminate\Support\Str;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;

class VehicleMakeManager extends Component
{
    use WithCrudList;

    public bool $showForm = false;
    public array $form = [
        'slug' => '',
        'logo' => '',
        'is_active' => true,
        'sort_order' => 0,
        'translations' => ['ar' => ['name' => ''], 'en' => ['name' => '']],
    ];

    protected function rules(): array
    {
        return [
            'form.translations.ar.name' => ['required', 'string'],
            'form.translations.en.name' => ['required', 'string'],
        ];
    }

    public function openCreate(): void
    {
        $this->reset('form', 'editingId');
        $this->form['translations'] = ['ar' => ['name' => ''], 'en' => ['name' => '']];
        $this->form['is_active'] = true;
        $this->showForm = true;
    }

    public function edit(int $id): void
    {
        $m = VehicleMake::findOrFail($id);
        $this->editingId = $id;
        $this->form = [
            'slug' => $m->slug,
            'logo' => $m->logo,
            'is_active' => $m->is_active,
            'sort_order' => $m->sort_order,
            'translations' => [
                'ar' => ['name' => optional($m->translate('ar'))->name ?? ''],
                'en' => ['name' => optional($m->translate('en'))->name ?? ''],
            ],
        ];
        $this->showForm = true;
    }

    public function save(): void
    {
        $this->validate();
        $m = $this->editingId ? VehicleMake::findOrFail($this->editingId) : new VehicleMake();
        $m->fill([
            'slug' => $this->form['slug'] ?: Str::slug($this->form['translations']['en']['name']),
            'logo' => $this->form['logo'],
            'is_active' => (bool) $this->form['is_active'],
            'sort_order' => (int) $this->form['sort_order'],
        ])->save();
        foreach ($this->form['translations'] as $locale => $tr) {
            $m->translateOrNew($locale)->fill($tr);
        }
        $m->save();
        $this->showForm = false;
        $this->editingId = null;
        $this->dispatch('toast', icon: 'success', title: __('messages.success'));
    }

    public function confirmDelete(int $id): void
    {
        $this->dispatch('confirm-delete', id: $id);
    }
    #[On('delete-confirmed')]
    public function delete(int $id): void
    {
        VehicleMake::findOrFail($id)->delete();
        $this->dispatch('toast', icon: 'success', title: __('messages.deleted'));
    }

    #[Layout('components.admin.layout', ['title' => 'Vehicle Makes'])]
    public function render()
    {
        $items = VehicleMake::query()
            ->when($this->search, fn($q) => $q->whereHas('translations', fn($qb) => $qb->where('name', 'like', "%{$this->search}%")))
            ->withCount('models')
            ->orderBy($this->sortBy, $this->sortDir)
            ->paginate(15);
        return view('livewire.admin.vehicles.vehicle-make-manager', compact('items'));
    }
}
