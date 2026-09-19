<?php

namespace App\Livewire\Admin\Vehicles;

use App\Livewire\Concerns\WithCrudList;
use App\Models\Vehicle;
use App\Models\VehicleMake;
use App\Models\VehicleModel;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Attributes\Url;
use Livewire\Component;

class VehicleManager extends Component
{
    use \App\Livewire\Concerns\AuthorizesAdmin;

    use WithCrudList;

    #[Url]
    public ?int $makeId = null;
    #[Url]
    public ?int $modelId = null;

    public bool $showForm = false;
    public array $form = [
        'vehicle_make_id' => null,
        'vehicle_model_id' => null,
        'year_from' => null,
        'year_to' => null,
        'is_active' => true,
        'translations' => ['ar' => ['trim' => ''], 'en' => ['trim' => '']],
    ];

    protected function rules(): array
    {
        return [
            'form.vehicle_make_id' => ['required', 'integer', 'exists:vehicle_makes,id'],
            'form.vehicle_model_id' => ['required', 'integer', 'exists:vehicle_models,id'],
            'form.year_from' => ['nullable', 'integer', 'min:1980', 'max:2099'],
            'form.year_to' => ['nullable', 'integer', 'min:1980', 'max:2099'],
        ];
    }

    public function openCreate(): void
    {
        $this->authorizePermission('vehicles.create');
        $this->reset('form', 'editingId');
        $this->form['translations'] = ['ar' => ['trim' => ''], 'en' => ['trim' => '']];
        $this->form['vehicle_make_id'] = $this->makeId;
        $this->form['vehicle_model_id'] = $this->modelId;
        $this->form['is_active'] = true;
        $this->showForm = true;
    }

    public function edit(int $id): void
    {
        $this->authorizePermission('vehicles.update');
        $v = Vehicle::findOrFail($id);
        $this->editingId = $id;
        $this->form = [
            'vehicle_make_id' => $v->vehicle_make_id,
            'vehicle_model_id' => $v->vehicle_model_id,
            'year_from' => $v->year_from,
            'year_to' => $v->year_to,
            'is_active' => $v->is_active,
            'translations' => [
                'ar' => ['trim' => optional($v->translate('ar'))->trim ?? ''],
                'en' => ['trim' => optional($v->translate('en'))->trim ?? ''],
            ],
        ];
        $this->showForm = true;
    }

    public function save(): void
    {
        $this->authorizePermission($this->editingId ? 'vehicles.update' : 'vehicles.create');
        $this->validate();
        $v = $this->editingId ? Vehicle::findOrFail($this->editingId) : new Vehicle();
        $v->fill([
            'vehicle_make_id' => (int) $this->form['vehicle_make_id'],
            'vehicle_model_id' => (int) $this->form['vehicle_model_id'],
            'year_from' => $this->form['year_from'] ?: null,
            'year_to' => $this->form['year_to'] ?: null,
            'is_active' => (bool) $this->form['is_active'],
        ])->save();
        foreach ($this->form['translations'] as $locale => $tr) {
            $v->translateOrNew($locale)->fill($tr);
        }
        $v->save();
        $this->showForm = false;
        $this->editingId = null;
        $this->dispatch('toast', icon: 'success', title: __('messages.success'));
    }

    public function confirmDelete(int $id): void
    {
        $this->authorizePermission('vehicles.delete');
        $this->dispatch('confirm-delete', id: $id);
    }
    #[On('delete-confirmed')]
    public function delete(int $id): void
    {
        $this->authorizePermission('vehicles.delete');
        Vehicle::findOrFail($id)->delete();
        $this->dispatch('toast', icon: 'success', title: __('messages.deleted'));
    }

    #[Layout('components.admin.layout', ['title' => 'Vehicles'])]
    public function render()
    {
        $this->authorizePermission('vehicles.view');
        $items = Vehicle::query()
            ->with(['make', 'model'])
            ->when($this->makeId, fn($q) => $q->where('vehicle_make_id', $this->makeId))
            ->when($this->modelId, fn($q) => $q->where('vehicle_model_id', $this->modelId))
            ->orderBy($this->sortBy, $this->sortDir)
            ->paginate(15);
        $makes = VehicleMake::orderBy('id')->get();
        $models = VehicleModel::when($this->makeId ?: ($this->form['vehicle_make_id'] ?? null), fn($q, $mid) => $q->where('vehicle_make_id', $mid))->get();
        return view('livewire.admin.vehicles.vehicle-manager', compact('items', 'makes', 'models'));
    }
}
