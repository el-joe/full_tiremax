<?php

namespace App\Livewire\Admin\Admins;

use App\Livewire\Concerns\AuthorizesAdmin;
use App\Livewire\Concerns\WithCrudList;
use App\Models\Admin;
use App\Traits\LogsAdminActions;
use Illuminate\Validation\ValidationException;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Attributes\Url;
use Livewire\Component;
use Livewire\WithFileUploads;
use Spatie\Permission\Models\Role;

class AdminManager extends Component
{
    use AuthorizesAdmin, WithCrudList, LogsAdminActions, WithFileUploads;

    #[Url(as: 'role', keep: false)]
    public string $roleFilter = '';
    #[Url(as: 'active', keep: false)]
    public string $activeFilter = '';
    #[Url(as: 'trashed', keep: false)]
    public string $trashed = '';

    protected array $filterKeys = ['roleFilter', 'activeFilter', 'trashed'];
    protected array $sortable = ['id', 'name', 'email', 'last_login_at', 'created_at'];

    public bool $showForm = false;
    public $avatarUpload = null;

    public array $form = [
        'name' => '', 'email' => '', 'phone' => '', 'password' => '',
        'is_active' => true, 'roles' => [],
    ];

    protected function rules(): array
    {
        return [
            'form.name' => ['required', 'string', 'max:120'],
            'form.email' => ['required', 'email', 'max:190', 'unique:admins,email' . ($this->editingId ? ',' . $this->editingId : '')],
            'form.phone' => ['nullable', 'string', 'max:30'],
            'form.password' => [$this->editingId ? 'nullable' : 'required', 'string', 'min:8'],
            'form.is_active' => ['boolean'],
            'form.roles' => ['array'],
            'form.roles.*' => ['string'],
            'avatarUpload' => ['nullable', 'image', 'max:2048'],
        ];
    }

    protected function isLastActiveSuper(Admin $admin): bool
    {
        if (! $admin->is_active || $admin->trashed() || ! $admin->hasRole('super-admin')) {
            return false;
        }
        return Admin::role('super-admin')->where('is_active', true)->where('id', '!=', $admin->id)->doesntExist();
    }

    protected function fail(string $key, string $msg): void
    {
        $this->toast($msg, 'error');
        throw ValidationException::withMessages([$key => $msg]);
    }

    public function openCreate(): void
    {
        $this->authorizePermission('admins.create');
        $this->reset('form', 'editingId', 'avatarUpload');
        $this->form['is_active'] = true;
        $this->form['roles'] = [];
        $this->showForm = true;
    }

    public function edit(int $id): void
    {
        $this->authorizePermission('admins.update');
        $a = Admin::findOrFail($id);
        $this->editingId = $id;
        $this->avatarUpload = null;
        $this->form = [
            'name' => $a->name, 'email' => $a->email, 'phone' => (string) $a->phone, 'password' => '',
            'is_active' => (bool) $a->is_active,
            'roles' => $a->roles->pluck('name')->all(),
        ];
        $this->showForm = true;
    }

    public function save(): void
    {
        $this->authorizePermission($this->editingId ? 'admins.update' : 'admins.create');
        $this->validate();
        $me = auth('admin')->user();
        $roles = array_values(array_unique($this->form['roles'] ?? []));
        $roles = Role::where('guard_name', 'admin')->whereIn('name', $roles)->pluck('name')->all();

        $admin = $this->editingId ? Admin::findOrFail($this->editingId) : new Admin();
        $isNew = ! $admin->exists;
        $oldRoles = $isNew ? [] : $admin->roles->pluck('name')->sort()->values()->all();
        $newRoles = collect($roles)->sort()->values()->all();
        $rolesChanged = $oldRoles !== $newRoles;

        if ($rolesChanged) {
            if (! $me->can('admins.update')) {
                abort(403);
            }
            $touchesSuper = in_array('super-admin', $oldRoles) !== in_array('super-admin', $newRoles);
            if ($touchesSuper && ! $me->hasRole('super-admin')) {
                $this->fail('form.roles', __('messages.admin.only_super_assign'));
            }
        }
        if (! $isNew && $admin->id === $me->id && ! $this->form['is_active']) {
            $this->fail('form.is_active', __('messages.admin.cannot_self_deactivate'));
        }
        if (! $isNew) {
            $losesSuper = ! $this->form['is_active'] || ! in_array('super-admin', $newRoles);
            if ($losesSuper && $this->isLastActiveSuper($admin)) {
                $this->fail('form.roles', __('messages.admin.last_super_admin'));
            }
        }

        $data = [
            'name' => $this->form['name'],
            'email' => $this->form['email'],
            'phone' => $this->form['phone'] ?: null,
            'is_active' => (bool) $this->form['is_active'],
        ];
        if ($this->form['password']) {
            $data['password'] = $this->form['password'];
        }
        if ($this->avatarUpload) {
            $data['avatar'] = $this->avatarUpload->store('avatars', 'public');
        }
        $admin->fill($data)->save();

        if ($isNew || $rolesChanged) {
            $admin->syncRoles($roles);
        }

        $this->logAction($isNew ? 'admin.created' : 'admin.updated', $admin,
            $isNew ? [] : ['roles' => $oldRoles],
            ['name' => $admin->name, 'email' => $admin->email, 'is_active' => $admin->is_active, 'roles' => $newRoles]);

        $this->showForm = false;
        $this->editingId = null;
        $this->avatarUpload = null;
        $this->toast(__('messages.success'));
    }

    public function toggleActive(int $id): void
    {
        $this->authorizePermission('admins.update');
        $admin = Admin::findOrFail($id);
        if ($admin->is_active) {
            if ($admin->id === auth('admin')->id()) {
                $this->fail('toggle', __('messages.admin.cannot_self_deactivate'));
            }
            if ($this->isLastActiveSuper($admin)) {
                $this->fail('toggle', __('messages.admin.last_super_admin'));
            }
        }
        $was = $admin->is_active;
        $admin->update(['is_active' => ! $was]);
        $this->logAction('admin.toggled', $admin, ['is_active' => $was], ['is_active' => $admin->is_active]);
        $this->toast(__('messages.success'));
    }

    public function confirmDelete(int $id): void
    {
        $this->authorizePermission('admins.delete');
        $this->dispatch('confirm-delete', id: $id);
    }

    #[On('delete-confirmed')]
    public function delete(int $id): void
    {
        $this->authorizePermission('admins.delete');
        $admin = Admin::findOrFail($id);
        if ($admin->id === auth('admin')->id()) {
            $this->fail('delete', __('messages.admin.cannot_self_delete'));
        }
        if ($this->isLastActiveSuper($admin)) {
            $this->fail('delete', __('messages.admin.last_super_admin'));
        }
        $admin->delete();
        $this->logAction('admin.deleted', $admin, ['name' => $admin->name, 'email' => $admin->email]);
        $this->toast(__('messages.deleted'));
    }

    public function restore(int $id): void
    {
        $this->authorizePermission('admins.delete');
        $admin = Admin::onlyTrashed()->findOrFail($id);
        $admin->restore();
        $this->logAction('admin.restored', $admin);
        $this->toast(__('messages.success'));
    }

    #[Layout('components.admin.layout', ['title' => 'Admins'])]
    public function render()
    {
        $this->authorizePermission('admins.view');
        $s = $this->search;

        $admins = Admin::query()->with('roles')
            ->when($this->trashed === 'only', fn ($q) => $q->onlyTrashed())
            ->when($this->trashed === 'with', fn ($q) => $q->withTrashed())
            ->when($s !== '', fn ($q) => $q->where(fn ($w) => $w
                ->where('name', 'like', "%{$s}%")->orWhere('email', 'like', "%{$s}%")->orWhere('phone', 'like', "%{$s}%")))
            ->when($this->roleFilter !== '', fn ($q) => $q->whereHas('roles', fn ($r) => $r->where('name', $this->roleFilter)))
            ->when($this->activeFilter !== '', fn ($q) => $q->where('is_active', $this->activeFilter === '1'))
            ->tap(fn ($q) => $this->applySort($q))
            ->paginate($this->pageSize());

        $allRoles = Role::where('guard_name', 'admin')->orderBy('name')->pluck('name');

        return view('livewire.admin.admins.admin-manager', compact('admins', 'allRoles'));
    }
}
