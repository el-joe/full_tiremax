<?php

namespace App\Livewire\Admin\Categories;

use App\Livewire\Concerns\WithCrudList;
use App\Models\Category;
use Illuminate\Support\Str;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;

class CategoryManager extends Component
{
    use \App\Livewire\Concerns\AuthorizesAdmin;

    use WithCrudList;

    public bool $showForm = false;
    public array $form = [
        'slug' => '',
        'product_type' => 'tire',
        'icon' => '',
        'is_active' => true,
        'sort_order' => 0,
        'translations' => ['ar' => ['name' => '', 'description' => ''], 'en' => ['name' => '', 'description' => '']],
    ];

    protected function rules(): array
    {
        return [
            'form.translations.ar.name' => ['required', 'string', 'max:120'],
            'form.translations.en.name' => ['required', 'string', 'max:120'],
            'form.product_type' => ['required', 'in:tire,battery'],
        ];
    }

    public function openCreate(): void
    {
        $this->authorizePermission('categories.create');
        $this->reset('form', 'editingId');
        $this->form['translations'] = ['ar' => ['name' => '', 'description' => ''], 'en' => ['name' => '', 'description' => '']];
        $this->form['product_type'] = 'tire';
        $this->form['is_active'] = true;
        $this->showForm = true;
    }

    public function edit(int $id): void
    {
        $this->authorizePermission('categories.update');
        $c = Category::findOrFail($id);
        $this->editingId = $id;
        $this->form = [
            'slug' => $c->slug,
            'product_type' => $c->product_type,
            'icon' => $c->icon,
            'is_active' => $c->is_active,
            'sort_order' => $c->sort_order,
            'translations' => [
                'ar' => ['name' => optional($c->translate('ar'))->name ?? '', 'description' => optional($c->translate('ar'))->description ?? ''],
                'en' => ['name' => optional($c->translate('en'))->name ?? '', 'description' => optional($c->translate('en'))->description ?? ''],
            ],
        ];
        $this->showForm = true;
    }

    public function save(): void
    {
        $this->authorizePermission($this->editingId ? 'categories.update' : 'categories.create');
        $this->validate();
        $c = $this->editingId ? Category::findOrFail($this->editingId) : new Category();
        $c->fill([
            'slug' => $this->form['slug'] ?: Str::slug($this->form['translations']['en']['name']),
            'product_type' => $this->form['product_type'],
            'icon' => $this->form['icon'],
            'is_active' => $this->form['is_active'],
            'sort_order' => (int) $this->form['sort_order'],
        ])->save();
        foreach ($this->form['translations'] as $locale => $tr) {
            $c->translateOrNew($locale)->fill($tr);
        }
        $c->save();
        $this->showForm = false;
        $this->editingId = null;
        $this->dispatch('toast', icon: 'success', title: __('messages.success'));
    }

    public function confirmDelete(int $id): void
    {
        $this->authorizePermission('categories.delete');
        $this->dispatch('confirm-delete', id: $id);
    }

    #[On('delete-confirmed')]
    public function delete(int $id): void
    {
        $this->authorizePermission('categories.delete');
        Category::findOrFail($id)->delete();
        $this->dispatch('toast', icon: 'success', title: __('messages.deleted'));
    }

    #[Layout('components.admin.layout', ['title' => 'Categories'])]
    public function render()
    {
        $this->authorizePermission('categories.view');
        $items = Category::query()
            ->when($this->search, fn($q) => $q->whereHas('translations', fn($qb) => $qb->where('name', 'like', "%{$this->search}%")))
            ->orderBy($this->sortBy, $this->sortDir)
            ->paginate(15);
        return view('livewire.admin.categories.category-manager', compact('items'));
    }
}
