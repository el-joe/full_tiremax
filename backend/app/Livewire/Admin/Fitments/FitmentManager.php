<?php

namespace App\Livewire\Admin\Fitments;

use App\Livewire\Concerns\WithCrudList;
use App\Models\Fitment;
use App\Models\Product;
use App\Models\Vehicle;
use App\Models\VehicleMake;
use App\Models\VehicleModel;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Attributes\Url;
use Livewire\Component;

class FitmentManager extends Component
{
    use WithCrudList;

    #[Url]
    public ?int $makeId = null;
    #[Url]
    public ?int $modelId = null;
    #[Url]
    public ?int $vehicleId = null;

    public bool $showForm = false;
    public array $form = [
        'vehicle_id' => null,
        'product_id' => null,
        'year_from' => null,
        'year_to' => null,
        'trim' => '',
        'is_alternative' => false,
        'is_excluded' => false,
        'is_oem' => false,
        'translations' => ['ar' => ['notes' => ''], 'en' => ['notes' => '']],
    ];

    protected function rules(): array
    {
        return [
            'form.vehicle_id' => ['required', 'integer', 'exists:vehicles,id'],
            'form.product_id' => ['required', 'integer', 'exists:products,id'],
            'form.year_from' => ['nullable', 'integer', 'min:1980', 'max:2099'],
            'form.year_to' => ['nullable', 'integer', 'min:1980', 'max:2099'],
        ];
    }

    public function openCreate(): void
    {
        $this->reset('form', 'editingId');
        $this->form['translations'] = ['ar' => ['notes' => ''], 'en' => ['notes' => '']];
        $this->form['vehicle_id'] = $this->vehicleId;
        $this->showForm = true;
    }

    public function edit(int $id): void
    {
        $f = Fitment::findOrFail($id);
        $this->editingId = $id;
        $this->form = [
            'vehicle_id' => $f->vehicle_id,
            'product_id' => $f->product_id,
            'year_from' => $f->year_from,
            'year_to' => $f->year_to,
            'trim' => $f->trim ?? '',
            'is_alternative' => $f->is_alternative,
            'is_excluded' => $f->is_excluded,
            'is_oem' => $f->is_oem,
            'translations' => [
                'ar' => ['notes' => optional($f->translate('ar'))->notes ?? ''],
                'en' => ['notes' => optional($f->translate('en'))->notes ?? ''],
            ],
        ];
        $this->showForm = true;
    }

    public function save(): void
    {
        $this->validate();
        $f = $this->editingId ? Fitment::findOrFail($this->editingId) : new Fitment();
        $f->fill([
            'vehicle_id' => (int) $this->form['vehicle_id'],
            'product_id' => (int) $this->form['product_id'],
            'year_from' => $this->form['year_from'] ?: null,
            'year_to' => $this->form['year_to'] ?: null,
            'trim' => $this->form['trim'] ?: null,
            'is_alternative' => (bool) $this->form['is_alternative'],
            'is_excluded' => (bool) $this->form['is_excluded'],
            'is_oem' => (bool) $this->form['is_oem'],
        ])->save();
        foreach ($this->form['translations'] as $loc => $tr) {
            $f->translateOrNew($loc)->fill($tr);
        }
        $f->save();
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
        Fitment::findOrFail($id)->delete();
        $this->dispatch('toast', icon: 'success', title: __('messages.deleted'));
    }

    #[Layout('components.admin.layout', ['title' => 'Fitments'])]
    public function render()
    {
        $items = Fitment::query()
            ->with(['vehicle.make', 'vehicle.model', 'product.brand'])
            ->when($this->vehicleId, fn($q) => $q->where('vehicle_id', $this->vehicleId))
            ->when($this->modelId, fn($q) => $q->whereHas('vehicle', fn($qb) => $qb->where('vehicle_model_id', $this->modelId)))
            ->when($this->makeId, fn($q) => $q->whereHas('vehicle', fn($qb) => $qb->where('vehicle_make_id', $this->makeId)))
            ->orderBy($this->sortBy, $this->sortDir)
            ->paginate(20);

        $makes = VehicleMake::all();
        $models = VehicleModel::when($this->makeId, fn($q, $m) => $q->where('vehicle_make_id', $m))->get();
        $vehicles = Vehicle::with(['make', 'model'])
            ->when($this->modelId, fn($q, $m) => $q->where('vehicle_model_id', $m))
            ->limit(200)->get();
        $products = Product::with('brand')->where('type', 'tire')->where('is_active', true)->limit(200)->get();

        return view('livewire.admin.fitments.fitment-manager', compact('items', 'makes', 'models', 'vehicles', 'products'));
    }
}
