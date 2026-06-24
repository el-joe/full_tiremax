<?php

namespace Database\Seeders;

use App\Models\PaymentGateway;
use Illuminate\Database\Seeder;

class PaymentGatewaySeeder extends Seeder
{
    public function run(): void
    {
        $gateways = [
            [
                'name'         => 'cod',
                'display_name' => 'Cash on Delivery',
                'driver'       => 'cod',
                'credentials'  => [],
                'settings'     => ['currency' => 'IQD'],
                'is_active'    => true,
            ],
            [
                'name'         => 'bank_transfer',
                'display_name' => 'Bank Transfer',
                'driver'       => 'bank_transfer',
                'credentials'  => [
                    'bank_name'      => 'Rafidain Bank',
                    'account_name'   => 'TireMax Co.',
                    'account_number' => '1234567890',
                    'iban'           => 'IQ98RAFI000000001234567890',
                    'swift'          => 'RAFIIQBA',
                ],
                'settings'     => ['currency' => 'IQD'],
                'is_active'    => true,
            ],
            [
                'name'         => 'paymob',
                'display_name' => 'Pay Online (Paymob)',
                'driver'       => 'paymob',
                'credentials'  => [
                    'api_key'        => env('PAYMOB_API_KEY', ''),
                    'integration_id' => env('PAYMOB_INTEGRATION_ID', ''),
                    'iframe_id'      => env('PAYMOB_IFRAME_ID', ''),
                    'hmac_secret'    => env('PAYMOB_HMAC_SECRET', ''),
                ],
                'settings'     => ['currency' => 'EGP'],
                'is_active'    => false, // enable after configuring credentials
            ],
        ];

        foreach ($gateways as $gateway) {
            PaymentGateway::updateOrCreate(
                ['name' => $gateway['name']],
                $gateway,
            );
        }
    }
}
