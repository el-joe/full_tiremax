<?php

namespace App\Models;

use App\Payment\BankTransferGateway;
use App\Payment\CodGateway;
use App\Payment\PaymobGateway;
use App\Contracts\PaymentGatewayInterface;
use Illuminate\Database\Eloquent\Casts\AsEncryptedArrayObject;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class PaymentGateway extends Model
{
    protected $fillable = [
        'name',
        'display_name',
        'driver',
        'credentials',
        'settings',
        'is_active',
    ];

    protected $casts = [
        'credentials' => AsEncryptedArrayObject::class,
        'settings'    => 'array',
        'is_active'   => 'boolean',
    ];

    public function payments(): HasMany
    {
        return $this->hasMany(Payment::class);
    }

    public function makeHandler(): PaymentGatewayInterface
    {
        return match ($this->driver) {
            'cod'           => new CodGateway($this),
            'bank_transfer' => new BankTransferGateway($this),
            'paymob'        => new PaymobGateway($this),
            default         => throw new \InvalidArgumentException("Unknown payment driver: {$this->driver}"),
        };
    }
}
