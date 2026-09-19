<?php

namespace App\Support;

use App\Models\Customer;
use Illuminate\Http\Request;

/** Resolves who is calling: an authenticated customer OR an anonymous guest identified by X-Guest-Token. */
class Actor
{
    public const HEADER = 'X-Guest-Token';

    public function __construct(public readonly ?Customer $customer, public readonly ?string $guestToken)
    {
    }

    public static function fromRequest(Request $request): self
    {
        $customer = null;
        try {
            $u = auth('api')->user();
            $customer = $u instanceof Customer ? $u : null;
        } catch (\Throwable $e) {
            $customer = null;
        }

        return new self($customer, self::sanitizeToken($request->header(self::HEADER)));
    }

    public static function sanitizeToken(?string $token): ?string
    {
        $token = $token !== null ? trim($token) : null;
        return ($token !== null && preg_match('/^[A-Za-z0-9_-]{16,64}$/', $token)) ? $token : null;
    }

    public function require(): self
    {
        if (!$this->customer && !$this->guestToken) {
            throw ApiException::unauthorized(__('messages.unauthenticated'));
        }
        return $this;
    }

    /** Does the actor own this order/booking/cart-like model (customer_id + guest_token columns)? */
    public function owns($model): bool
    {
        if ($this->customer) {
            return $model->customer_id !== null && (int) $model->customer_id === (int) $this->customer->id;
        }
        return $model->customer_id === null
            && $this->guestToken !== null
            && $model->guest_token !== null
            && hash_equals((string) $model->guest_token, $this->guestToken);
    }
}
