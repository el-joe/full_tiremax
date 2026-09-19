<?php

namespace App\Livewire\Admin\Brands;

use Livewire\Attributes\Url;
use App\Livewire\Concerns\WithCrudList;
use App\Models\Brand;
use Illuminate\Support\Str;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;

class BrandManager extends Component
{
    use \App\Livewire\Concerns\AuthorizesAdmin;

    use WithCrudList;

    #[Url(as: 'active', keep: false)]
    public string $activeFilter = '';

    protected array $filterKeys = ['activeFilter'];
    protected array $sortable = ['id', 'sort_order', 'created_at'];


    public bool $showForm = false;

    public array $form = [
        'slug' => '',
        'country' => '',
        'logo' => '',
        'is_active' => true,
        'sort_order' => 0,
        'translations' => ['ar' => ['name' => '', 'description' => ''], 'en' => ['name' => '', 'description' => '']],
    ];

    protected function rules(): array
    {
        return [
            'form.translations.ar.name' => ['required', 'string', 'max:120'],
            'form.translations.en.name' => ['required', 'string', 'max:120'],
            'form.country' => ['nullable', 'string', 'max:60'],
            'form.is_active' => ['boolean'],
            'form.sort_order' => ['integer', 'min:0'],
        ];
    }

    public function openCreate(): void
    {
        $this->authorizePermission('brands.create');
        $this->reset('form', 'editingId');
        $this->form['translations'] = ['ar' => ['name' => '', 'description' => ''], 'en' => ['name' => '', 'description' => '']];
        $this->form['is_active'] = true;
        $this->showForm = true;
    }

    public function edit(int $id): void
    {
        $this->authorizePermission('brands.update');
        $brand = Brand::with('translations')->findOrFail($id);
        $this->editingId = $id;
        $this->form = [
            'slug' => $brand->slug,
            'country' => $brand->country,
            'logo' => $brand->logo,
            'is_active' => $brand->is_active,
            'sort_order' => $brand->sort_order,
            'translations' => [
                'ar' => ['name' => optional($brand->translate('ar'))->name ?? '', 'description' => optional($brand->translate('ar'))->description ?? ''],
                'en' => ['name' => optional($brand->translate('en'))->name ?? '', 'description' => optional($brand->translate('en'))->description ?? ''],
            ],
        ];
        $this->showForm = true;
    }

    public function save(): void
    {
        $this->authorizePermission($this->editingId ? 'brands.update' : 'brands.create');
        $this->validate();
        $slug = $this->form['slug'] ?: Str::slug($this->form['translations']['en']['name']);

        $brand = $this->editingId
            ? Brand::findOrFail($this->editingId)
            : new Brand();

        $brand->fill([
            'slug' => $slug,
            'country' => $this->form['country'],
            'logo' => $this->form['logo'],
            'is_active' => $this->form['is_active'],
            'sort_order' => (int) $this->form['sort_order'],
        ])->save();

        foreach ($this->form['translations'] as $locale => $tr) {
            $brand->translateOrNew($locale)->fill($tr);
        }
        $brand->save();

        $this->showForm = false;
        $this->editingId = null;
        $this->toast(__('messages.success'));
    }

    public function confirmDelete(int $id): void
    {
        $this->authorizePermission('brands.delete');
        $this->dispatch('confirm-delete', id: $id);
    }

    #[On('delete-confirmed')]
    public function delete(int $id): void
    {
        $this->authorizePermission('brands.delete');
        Brand::findOrFail($id)->delete();
        $this->toast(__('messages.deleted'));
    }

    #[Layout('components.admin.layout', ['title' => 'Brands'])]
    public function render()
    {
        $this->authorizePermission('brands.view');
        $brands = Brand::query()->with('translations')
            ->when($this->activeFilter !== '', fn ($q) => $q->where('is_active', $this->activeFilter === '1'))
            ->searchTranslated($this->search, ['name'], ['slug'])
            ->tap(fn ($q) => $this->applySort($q))
            ->paginate($this->pageSize());

        return view('livewire.admin.brands.brand-manager', compact('brands'));
    }
}
