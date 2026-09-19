<?php

namespace App\Livewire\Admin\Branches;

use Livewire\Attributes\Url;
use App\Livewire\Concerns\WithCrudList;
use App\Models\Branch;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;

class BranchManager extends Component
{
    use \App\Livewire\Concerns\AuthorizesAdmin;

    use WithCrudList;

    #[Url(as: 'active', keep: false)]
    public string $activeFilter = '';
    #[Url(as: 'main', keep: false)]
    public string $mainFilter = '';

    protected array $filterKeys = ['activeFilter', 'mainFilter'];
    protected array $sortable = ['id', 'created_at'];


    public bool $showForm = false;
    public array $form = [
        'code' => '',
        'phone' => '',
        'email' => '',
        'latitude' => null,
        'longitude' => null,
        'is_main' => false,
        'is_active' => true,
        'default_capacity' => 2,
        'auto_confirm_bookings' => false,
        'translations' => ['ar' => ['name' => '', 'address' => '', 'description' => ''], 'en' => ['name' => '', 'address' => '', 'description' => '']],
    ];

    protected function rules(): array
    {
        return [
            'form.code' => ['required', 'string', 'max:30'],
            'form.translations.ar.name' => ['required', 'string'],
            'form.translations.en.name' => ['required', 'string'],
        ];
    }

    public function openCreate(): void
    {
        $this->authorizePermission('branches.create');
        $this->reset('form', 'editingId');
        $this->form['translations'] = ['ar' => ['name' => '', 'address' => '', 'description' => ''], 'en' => ['name' => '', 'address' => '', 'description' => '']];
        $this->form['is_active'] = true;
        $this->form['default_capacity'] = 2;
        $this->showForm = true;
    }

    public function edit(int $id): void
    {
        $this->authorizePermission('branches.update');
        $b = Branch::findOrFail($id);
        $this->editingId = $id;
        $this->form = [
            'code' => $b->code,
            'phone' => $b->phone,
            'email' => $b->email,
            'latitude' => $b->latitude,
            'longitude' => $b->longitude,
            'is_main' => $b->is_main,
            'is_active' => $b->is_active,
            'default_capacity' => $b->default_capacity,
            'auto_confirm_bookings' => $b->auto_confirm_bookings,
            'translations' => [
                'ar' => ['name' => optional($b->translate('ar'))->name ?? '', 'address' => optional($b->translate('ar'))->address ?? '', 'description' => optional($b->translate('ar'))->description ?? ''],
                'en' => ['name' => optional($b->translate('en'))->name ?? '', 'address' => optional($b->translate('en'))->address ?? '', 'description' => optional($b->translate('en'))->description ?? ''],
            ],
        ];
        $this->showForm = true;
    }

    public function save(): void
    {
        $this->authorizePermission($this->editingId ? 'branches.update' : 'branches.create');
        $this->validate();
        $b = $this->editingId ? Branch::findOrFail($this->editingId) : new Branch();
        $b->fill([
            'code' => $this->form['code'],
            'phone' => $this->form['phone'],
            'email' => $this->form['email'],
            'latitude' => $this->form['latitude'] ?: null,
            'longitude' => $this->form['longitude'] ?: null,
            'is_main' => (bool) $this->form['is_main'],
            'is_active' => (bool) $this->form['is_active'],
            'default_capacity' => (int) $this->form['default_capacity'],
            'auto_confirm_bookings' => (bool) $this->form['auto_confirm_bookings'],
        ])->save();
        foreach ($this->form['translations'] as $locale => $tr) {
            $b->translateOrNew($locale)->fill($tr);
        }
        $b->save();
        $this->showForm = false;
        $this->editingId = null;
        $this->dispatch('toast', icon: 'success', title: __('messages.success'));
    }

    public function confirmDelete(int $id): void
    {
        $this->authorizePermission('branches.delete');
        $this->dispatch('confirm-delete', id: $id);
    }
    #[On('delete-confirmed')]
    public function delete(int $id): void
    {
        $this->authorizePermission('branches.delete');
        Branch::findOrFail($id)->delete();
        $this->dispatch('toast', icon: 'success', title: __('messages.deleted'));
    }

    #[Layout('components.admin.layout', ['title' => 'Branches'])]
    public function render()
    {
        $this->authorizePermission('branches.view');
        $items = Branch::query()
            ->with('translations')
            ->when($this->activeFilter !== '', fn ($q) => $q->where('is_active', $this->activeFilter === '1'))
            ->when($this->mainFilter !== '', fn ($q) => $q->where('is_main', $this->mainFilter === '1'))
            ->searchTranslated($this->search, ['name', 'address'], ['code', 'phone'])
            ->tap(fn ($q) => $this->applySort($q))
            ->paginate($this->pageSize());
        return view('livewire.admin.branches.branch-manager', compact('items'));
    }
}
