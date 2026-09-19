<?php

namespace App\Livewire\Admin\Roles;

use App\Livewire\Concerns\AuthorizesAdmin;
use App\Livewire\Concerns\WithCrudList;
use App\Support\AdminPermissions;
use App\Traits\LogsAdminActions;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;
use Livewire\Attributes\Layout;
use Livewire\Attributes\On;
use Livewire\Component;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;
use Spatie\Permission\PermissionRegistrar;

class RoleManager extends Component
{
    use AuthorizesAdmin, WithCrudList, LogsAdminActions;

    protected array $filterKeys = [];
    protected array $sortable = ['name', 'id'];

    public bool $showForm = false;
    public string $name = '';
    /** @var array<int, string> */
    public array $permissions = [];

    protected function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:60', 'regex:/^[a-z0-9]+(?:[-_][a-z0-9]+)*$/',
                Rule::unique('roles', 'name')->where('guard_name', 'admin')->ignore($this->editingId)],
            'permissions' => ['array'],
            'permissions.*' => [Rule::in(AdminPermissions::all())],
        ];
    }

    protected function fail(string $key, string $msg): void
    {
        $this->toast($msg, 'error');
        throw ValidationException::withMessages([$key => $msg]);
    }

    public function openCreate(): void
    {
        $this->authorizePermission('roles.create');
        $this->reset('name', 'permissions', 'editingId');
        $this->showForm = true;
    }

    public function edit(int $id): void
    {
        $this->authorizePermission('roles.update');
        $role = Role::where('guard_name', 'admin')->findOrFail($id);
        if ($role->name === 'super-admin') {
            $this->fail('name', __('messages.admin.super_role_readonly'));
        }
        $this->editingId = $id;
        $this->name = $role->name;
        $this->permissions = $role->permissions->pluck('name')->all();
        $this->showForm = true;
    }

    public function save(): void
    {
        $this->authorizePermission($this->editingId ? 'roles.update' : 'roles.create');
        $this->name = strtolower(trim($this->name));
        $this->validate();

        if ($this->editingId) {
            $role = Role::where('guard_name', 'admin')->findOrFail($this->editingId);
            if ($role->name === 'super-admin') {
                $this->fail('name', __('messages.admin.super_role_readonly'));
            }
            $old = $role->permissions->pluck('name')->sort()->values()->all();
            $role->update(['name' => $this->name]);
        } else {
            if ($this->name === 'super-admin') {
                $this->fail('name', __('messages.admin.super_role_readonly'));
            }
            $role = Role::create(['name' => $this->name, 'guard_name' => 'admin']);
            $old = [];
        }

        $perms = array_values(array_unique($this->permissions));
        foreach ($perms as $p) {
            Permission::findOrCreate($p, 'admin');
        }
        $role->syncPermissions($perms);
        app(PermissionRegistrar::class)->forgetCachedPermissions();

        $this->logAction($this->editingId ? 'role.updated' : 'role.created', $role,
            ['permissions' => $old], ['name' => $role->name, 'permissions' => collect($perms)->sort()->values()->all()]);

        $this->showForm = false;
        $this->editingId = null;
        $this->toast(__('messages.success'));
    }

    public function toggleRow(string $module): void
    {
        $row = AdminPermissions::forModule($module);
        $this->permissions = count(array_diff($row, $this->permissions)) === 0
            ? array_values(array_diff($this->permissions, $row))
            : array_values(array_unique([...$this->permissions, ...$row]));
    }

    public function toggleColumn(string $action): void
    {
        $col = [];
        foreach (AdminPermissions::groups() as $module => $actions) {
            if (in_array($action, $actions)) {
                $col[] = "$module.$action";
            }
        }
        $this->permissions = count(array_diff($col, $this->permissions)) === 0
            ? array_values(array_diff($this->permissions, $col))
            : array_values(array_unique([...$this->permissions, ...$col]));
    }

    public function confirmDelete(int $id): void
    {
        $this->authorizePermission('roles.delete');
        $this->dispatch('confirm-delete', id: $id);
    }

    #[On('delete-confirmed')]
    public function delete(int $id): void
    {
        $this->authorizePermission('roles.delete');
        $role = Role::where('guard_name', 'admin')->findOrFail($id);
        if ($role->name === 'super-admin') {
            $this->fail('delete', __('messages.admin.super_role_readonly'));
        }
        $count = $role->users()->count();
        if ($count > 0) {
            $this->fail('delete', __('messages.admin.role_has_admins', ['count' => $count]));
        }
        $role->delete();
        app(PermissionRegistrar::class)->forgetCachedPermissions();
        $this->logAction('role.deleted', $role, ['name' => $role->name]);
        $this->toast(__('messages.deleted'));
    }

    #[Layout('components.admin.layout', ['title' => 'Roles'])]
    public function render()
    {
        $this->authorizePermission('roles.view');
        $s = $this->search;
        $roles = Role::query()->where('guard_name', 'admin')
            ->withCount('permissions')
            ->when($s !== '', fn ($q) => $q->where('name', 'like', "%{$s}%"))
            ->tap(fn ($q) => $this->applySort($q, 'name', 'asc'))
            ->paginate($this->pageSize());
        // admin count via spatie pivot
        $counts = \DB::table(config('permission.table_names.model_has_roles'))
            ->whereIn('role_id', $roles->pluck('id'))
            ->where('model_type', \App\Models\Admin::class)
            ->selectRaw('role_id, count(*) c')->groupBy('role_id')->pluck('c', 'role_id');

        return view('livewire.admin.roles.role-manager', [
            'roles' => $roles, 'counts' => $counts, 'groups' => AdminPermissions::groups(),
        ]);
    }
}
