<?php

namespace App\Livewire\Admin\Vehicles;

use App\Livewire\Concerns\WithCrudList;
use App\Models\VehicleMake;
use App\Models\VehicleModel;
use Illuminate\Support\Str;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Attributes\Url;
use Livewire\Component;

class VehicleModelManager extends Component
{
    use \App\Livewire\Concerns\AuthorizesAdmin;

    use WithCrudList;

    #[Url(as: 'make', keep: false)]
    public ?int $makeId = null;
    #[Url(as: 'active', keep: false)]
    public string $activeFilter = '';

    protected array $filterKeys = ['makeId', 'activeFilter'];
    protected array $sortable = ['id', 'sort_order', 'created_at'];



    public bool $showForm = false;
    public array $form = [
        'vehicle_make_id' => null,
        'slug' => '',
        'is_active' => true,
        'sort_order' => 0,
        'translations' => ['ar' => ['name' => ''], 'en' => ['name' => '']],
    ];

    protected function rules(): array
    {
        return [
            'form.vehicle_make_id' => ['required', 'integer', 'exists:vehicle_makes,id'],
            'form.translations.ar.name' => ['required', 'string'],
            'form.translations.en.name' => ['required', 'string'],
        ];
    }

    public function openCreate(): void
    {
        $this->authorizePermission('vehicles.create');
        $this->reset('form', 'editingId');
        $this->form['translations'] = ['ar' => ['name' => ''], 'en' => ['name' => '']];
        $this->form['vehicle_make_id'] = $this->makeId;
        $this->form['is_active'] = true;
        $this->showForm = true;
    }

    public function edit(int $id): void
    {
        $this->authorizePermission('vehicles.update');
        $m = VehicleModel::findOrFail($id);
        $this->editingId = $id;
        $this->form = [
            'vehicle_make_id' => $m->vehicle_make_id,
            'slug' => $m->slug,
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
        $this->authorizePermission($this->editingId ? 'vehicles.update' : 'vehicles.create');
        $this->validate();
        $m = $this->editingId ? VehicleModel::findOrFail($this->editingId) : new VehicleModel();
        $m->fill([
            'vehicle_make_id' => (int) $this->form['vehicle_make_id'],
            'slug' => $this->form['slug'] ?: Str::slug($this->form['translations']['en']['name']),
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
        $this->authorizePermission('vehicles.delete');
        $this->dispatch('confirm-delete', id: $id);
    }
    #[On('delete-confirmed')]
    public function delete(int $id): void
    {
        $this->authorizePermission('vehicles.delete');
        VehicleModel::findOrFail($id)->delete();
        $this->dispatch('toast', icon: 'success', title: __('messages.deleted'));
    }

    #[Layout('components.admin.layout', ['title' => 'Vehicle Models'])]
    public function render()
    {
        $this->authorizePermission('vehicles.view');
        $items = VehicleModel::query()
            ->with('make.translations')
            ->when($this->makeId, fn ($q) => $q->where('vehicle_make_id', $this->makeId))
            ->when($this->activeFilter !== '', fn ($q) => $q->where('is_active', $this->activeFilter === '1'))
            ->searchTranslated($this->search, ['name'], ['slug'])
            ->tap(fn ($q) => $this->applySort($q))
            ->paginate($this->pageSize());
        $makes = VehicleMake::with('translations')->get();
        return view('livewire.admin.vehicles.vehicle-model-manager', compact('items', 'makes'));
    }
}
