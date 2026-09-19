<?php

namespace App\Livewire\Admin\Offers;

use Livewire\Attributes\Url;
use App\Livewire\Concerns\WithCrudList;
use App\Models\Offer;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;

class OfferManager extends Component
{
    use \App\Livewire\Concerns\AuthorizesAdmin;

    use WithCrudList;

    #[Url(as: 'active', keep: false)]
    public string $activeFilter = '';
    #[Url(as: 'status', keep: false)]
    public string $statusFilter = '';
    #[Url(as: 'type', keep: false)]
    public string $typeFilter = '';

    protected array $filterKeys = ['activeFilter', 'statusFilter', 'typeFilter'];
    protected array $sortable = ['id', 'ends_at', 'created_at'];


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
        $this->authorizePermission('offers.create');
        $this->reset('form', 'editingId');
        $this->form['translations'] = ['ar' => ['title' => '', 'description' => ''], 'en' => ['title' => '', 'description' => '']];
        $this->form['is_active'] = true;
        $this->form['discount_type'] = 'percent';
        $this->showForm = true;
    }

    public function edit(int $id): void
    {
        $this->authorizePermission('offers.update');
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
        $this->authorizePermission($this->editingId ? 'offers.update' : 'offers.create');
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
        $this->authorizePermission('offers.delete');
        $this->dispatch('confirm-delete', id: $id);
    }
    #[On('delete-confirmed')]
    public function delete(int $id): void
    {
        $this->authorizePermission('offers.delete');
        Offer::findOrFail($id)->delete();
        $this->dispatch('toast', icon: 'success', title: __('messages.deleted'));
    }

    #[Layout('components.admin.layout', ['title' => 'Offers'])]
    public function render()
    {
        $this->authorizePermission('offers.view');
        $items = Offer::query()
            ->when($this->activeFilter !== '', fn ($q) => $q->where('is_active', $this->activeFilter === '1'))
            ->when($this->typeFilter !== '', fn ($q) => $q->where('discount_type', $this->typeFilter))
            ->when($this->statusFilter === 'live', fn ($q) => $q->where(fn ($w) => $w->whereNull('starts_at')->orWhere('starts_at', '<=', now()))
                ->where(fn ($w) => $w->whereNull('ends_at')->orWhere('ends_at', '>=', now())))
            ->when($this->statusFilter === 'upcoming', fn ($q) => $q->where('starts_at', '>', now()))
            ->when($this->statusFilter === 'expired', fn ($q) => $q->where('ends_at', '<', now()))
            ->searchTranslated($this->search, ['title'], ['code'])
            ->tap(fn ($q) => $this->applySort($q))
            ->paginate($this->pageSize());
        return view('livewire.admin.offers.offer-manager', compact('items'));
    }
}
