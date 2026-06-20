<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class AddressResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'          => $this->id,
            'full_name'   => $this->full_name,
            'phone'       => $this->phone,
            'governorate' => new GovernorateResource($this->whenLoaded('governorate')),
            'city'        => new CityResource($this->whenLoaded('city')),
            'address'     => $this->address,
            'is_default'  => $this->is_default,
        ];
    }
}
