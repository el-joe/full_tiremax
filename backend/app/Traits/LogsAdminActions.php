<?php

namespace App\Traits;

use App\Models\AuditLog;
use Illuminate\Database\Eloquent\Model;

trait LogsAdminActions
{
    protected function logAction(string $action, Model $model, array $old = [], array $new = []): void
    {
        AuditLog::create([
            'admin_id' => auth('admin')->id(),
            'action' => $action,
            'subject_type' => $model::class,
            'subject_id' => $model->getKey(),
            'changes' => ($old || $new) ? ['old' => $old, 'new' => $new] : null,
            'ip' => request()->ip(),
            'user_agent' => request()->userAgent(),
        ]);
    }
}
