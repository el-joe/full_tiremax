<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class BranchResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'code' => $this->code,
            'name' => $this->name,
            'address' => $this->address,
            'description' => $this->description,
            'phone' => $this->phone,
            'email' => $this->email,
            'latitude' => $this->latitude ? (float) $this->latitude : null,
            'longitude' => $this->longitude ? (float) $this->longitude : null,
            'is_main' => $this->is_main,
            'is_active' => $this->is_active,
            'schedules' => $this->whenLoaded('schedules', fn() => $this->schedules->map(fn($s) => [
                'day_of_week' => $s->day_of_week,
                'opens_at' => $s->opens_at,
                'closes_at' => $s->closes_at,
                'capacity' => $s->capacity,
                'is_closed' => $s->is_closed,
            ])),
        ];
    }
}
