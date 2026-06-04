<?php

namespace App\Livewire\Admin\Brands;

use App\Livewire\Concerns\WithCrudList;
use App\Models\Brand;
use Illuminate\Support\Str;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;

class BrandManager extends Component
{
    use WithCrudList;

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
        $this->reset('form', 'editingId');
        $this->form['translations'] = ['ar' => ['name' => '', 'description' => ''], 'en' => ['name' => '', 'description' => '']];
        $this->form['is_active'] = true;
        $this->showForm = true;
    }

    public function edit(int $id): void
    {
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
        $this->dispatch('confirm-delete', id: $id);
    }

    #[On('delete-confirmed')]
    public function delete(int $id): void
    {
        Brand::findOrFail($id)->delete();
        $this->toast(__('messages.deleted'));
    }

    #[Layout('components.admin.layout', ['title' => 'Brands'])]
    public function render()
    {
        $brands = Brand::query()
            ->when($this->search, fn($q) => $q->whereHas('translations', fn($qb) => $qb->where('name', 'like', "%{$this->search}%")))
            ->orderBy($this->sortBy, $this->sortDir)
            ->paginate(15);

        return view('livewire.admin.brands.brand-manager', compact('brands'));
    }
}
