<?php

namespace App\Livewire\Admin\Governorates;

use App\Livewire\Concerns\WithCrudList;
use App\Models\Governorate;
use Illuminate\Support\Str;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;

class GovernorateManager extends Component
{
    use \App\Livewire\Concerns\AuthorizesAdmin;

    use WithCrudList;

    public bool $showForm = false;
    public array $form = [
        'code' => '',
        'is_basra' => false,
        'shipping_fee' => 0,
        'is_active' => true,
        'sort_order' => 0,
        'translations' => ['ar' => ['name' => ''], 'en' => ['name' => '']],
    ];

    protected function rules(): array
    {
        return [
            'form.code' => ['required', 'string', 'max:30'],
            'form.translations.ar.name' => ['required', 'string', 'max:120'],
            'form.translations.en.name' => ['required', 'string', 'max:120'],
            'form.shipping_fee' => ['numeric', 'min:0'],
        ];
    }

    public function openCreate(): void
    {
        $this->authorizePermission('governorates.create');
        $this->reset('form', 'editingId');
        $this->form['translations'] = ['ar' => ['name' => ''], 'en' => ['name' => '']];
        $this->form['is_active'] = true;
        $this->showForm = true;
    }

    public function edit(int $id): void
    {
        $this->authorizePermission('governorates.update');
        $g = Governorate::findOrFail($id);
        $this->editingId = $id;
        $this->form = [
            'code' => $g->code,
            'is_basra' => $g->is_basra,
            'shipping_fee' => (float) $g->shipping_fee,
            'is_active' => $g->is_active,
            'sort_order' => $g->sort_order,
            'translations' => [
                'ar' => ['name' => optional($g->translate('ar'))->name ?? ''],
                'en' => ['name' => optional($g->translate('en'))->name ?? ''],
            ],
        ];
        $this->showForm = true;
    }

    public function save(): void
    {
        $this->authorizePermission($this->editingId ? 'governorates.update' : 'governorates.create');
        $this->validate();
        $g = $this->editingId ? Governorate::findOrFail($this->editingId) : new Governorate();
        $g->fill([
            'code' => $this->form['code'] ?: Str::slug($this->form['translations']['en']['name']),
            'is_basra' => (bool) $this->form['is_basra'],
            'shipping_fee' => (float) $this->form['shipping_fee'],
            'is_active' => (bool) $this->form['is_active'],
            'sort_order' => (int) $this->form['sort_order'],
        ])->save();
        foreach ($this->form['translations'] as $locale => $tr) {
            $g->translateOrNew($locale)->fill($tr);
        }
        $g->save();
        $this->showForm = false;
        $this->editingId = null;
        $this->dispatch('toast', icon: 'success', title: __('messages.success'));
    }

    public function confirmDelete(int $id): void
    {
        $this->authorizePermission('governorates.delete');
        $this->dispatch('confirm-delete', id: $id);
    }

    #[On('delete-confirmed')]
    public function delete(int $id): void
    {
        $this->authorizePermission('governorates.delete');
        Governorate::findOrFail($id)->delete();
        $this->dispatch('toast', icon: 'success', title: __('messages.deleted'));
    }

    #[Layout('components.admin.layout', ['title' => 'Governorates'])]
    public function render()
    {
        $this->authorizePermission('governorates.view');
        $items = Governorate::query()
            ->when($this->search, fn($q) => $q->where('code', 'like', "%{$this->search}%")
                ->orWhereHas('translations', fn($qb) => $qb->where('name', 'like', "%{$this->search}%")))
            ->orderBy($this->sortBy, $this->sortDir)
            ->paginate(20);
        return view('livewire.admin.governorates.governorate-manager', compact('items'));
    }
}
