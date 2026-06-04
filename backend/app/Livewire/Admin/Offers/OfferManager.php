<?php

namespace App\Livewire\Admin\Offers;

use App\Livewire\Concerns\WithCrudList;
use App\Models\Offer;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;

class OfferManager extends Component
{
    use WithCrudList;

    public bool $showForm = false;
    public array $form = [
        'code' => '',
        'discount_type' => 'percent',
        'discount_value' => 0,
        'min_subtotal' => 0,
        'usage_limit' => null,
        'starts_at' => null,
        'ends_at' => null,
        'is_active' => true,
        'translations' => ['ar' => ['title' => '', 'description' => ''], 'en' => ['title' => '', 'description' => '']],
    ];

    protected function rules(): array
    {
        return [
            'form.code' => ['required', 'string', 'max:60'],
            'form.discount_type' => ['required', 'in:percent,fixed'],
            'form.discount_value' => ['required', 'numeric', 'min:0'],
            'form.translations.ar.title' => ['required', 'string'],
            'form.translations.en.title' => ['required', 'string'],
        ];
    }

    public function openCreate(): void
    {
        $this->reset('form', 'editingId');
        $this->form['translations'] = ['ar' => ['title' => '', 'description' => ''], 'en' => ['title' => '', 'description' => '']];
        $this->form['is_active'] = true;
        $this->form['discount_type'] = 'percent';
        $this->showForm = true;
    }

    public function edit(int $id): void
    {
        $o = Offer::findOrFail($id);
        $this->editingId = $id;
        $this->form = [
            'code' => $o->code,
            'discount_type' => $o->discount_type,
            'discount_value' => (float) $o->discount_value,
            'min_subtotal' => (float) $o->min_subtotal,
            'usage_limit' => $o->usage_limit,
            'starts_at' => optional($o->starts_at)->format('Y-m-d\TH:i'),
            'ends_at' => optional($o->ends_at)->format('Y-m-d\TH:i'),
            'is_active' => $o->is_active,
            'translations' => [
                'ar' => ['title' => optional($o->translate('ar'))->title ?? '', 'description' => optional($o->translate('ar'))->description ?? ''],
                'en' => ['title' => optional($o->translate('en'))->title ?? '', 'description' => optional($o->translate('en'))->description ?? ''],
            ],
        ];
        $this->showForm = true;
    }

    public function save(): void
    {
        $this->validate();
        $o = $this->editingId ? Offer::findOrFail($this->editingId) : new Offer();
        $o->fill([
            'code' => $this->form['code'],
            'discount_type' => $this->form['discount_type'],
            'discount_value' => (float) $this->form['discount_value'],
            'min_subtotal' => (float) $this->form['min_subtotal'],
            'usage_limit' => $this->form['usage_limit'] ?: null,
            'starts_at' => $this->form['starts_at'] ?: null,
            'ends_at' => $this->form['ends_at'] ?: null,
            'is_active' => (bool) $this->form['is_active'],
        ])->save();
        foreach ($this->form['translations'] as $loc => $tr) {
            $o->translateOrNew($loc)->fill($tr);
        }
        $o->save();
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
        Offer::findOrFail($id)->delete();
        $this->dispatch('toast', icon: 'success', title: __('messages.deleted'));
    }

    #[Layout('components.admin.layout', ['title' => 'Offers'])]
    public function render()
    {
        $items = Offer::query()
            ->when($this->search, fn($q) => $q->where('code', 'like', "%{$this->search}%"))
            ->orderBy($this->sortBy, $this->sortDir)
            ->paginate(15);
        return view('livewire.admin.offers.offer-manager', compact('items'));
    }
}
