<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class VehicleResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'vehicle_model_id' => $this->vehicle_model_id,
            'year_from' => $this->year_from,
            'year_to' => $this->year_to,
            'trim_code' => $this->trim_code,
            'trim_name' => $this->trim_name,
            'engine' => $this->engine,
            'notes' => $this->notes,
            'model' => new VehicleModelResource($this->whenLoaded('model')),
        ];
    }
}
