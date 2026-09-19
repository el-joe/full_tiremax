<?php

namespace App\Livewire\Admin\PaymentGateways;

use App\Models\PaymentGateway;
use Livewire\Attributes\Layout;
use Livewire\Component;

class PaymentGatewayManager extends Component
{
    use \App\Livewire\Concerns\AuthorizesAdmin;

    public function toggleActive(int $id): void
    {
        $this->authorizePermission('payment_gateways.update');
        $gateway = PaymentGateway::findOrFail($id);
        $gateway->is_active = !$gateway->is_active;
        $gateway->save();
        $this->dispatch('toast', icon: 'success', title: __('messages.success'));
    }

    public function updateDisplayName(int $id, string $name): void
    {
        $this->authorizePermission('payment_gateways.update');
        $gateway = PaymentGateway::findOrFail($id);
        $gateway->display_name = $name;
        $gateway->save();
        $this->dispatch('toast', icon: 'success', title: __('messages.success'));
    }

    #[Layout('components.admin.layout', ['title' => 'Payment Gateways'])]
    public function render()
    {
        $this->authorizePermission('payment_gateways.view');
        $items = PaymentGateway::orderBy('id')->get();

        return view('livewire.admin.payment-gateways.payment-gateway-manager', compact('items'));
    }
}
