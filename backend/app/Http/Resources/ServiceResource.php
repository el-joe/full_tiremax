<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ServiceResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'slug' => $this->slug,
            'name' => $this->name,
            'description' => $this->description,
            'icon' => $this->icon,
            'image_url' => $this->image ? asset('storage/' . $this->image) : null,
            'duration_minutes' => $this->duration_minutes,
            'price' => (float) $this->price,
        ];
    }
}
