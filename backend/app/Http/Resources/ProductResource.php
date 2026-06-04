<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ProductResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'sku' => $this->sku,
            'type' => $this->type,
            'name' => $this->name,
            'short_description' => $this->short_description,
            'description' => $this->description,
            'pattern_name' => $this->pattern_name,
            'usage_notes' => $this->usage_notes,
            'price' => (float) $this->price,
            'sale_price' => $this->sale_price ? (float) $this->sale_price : null,
            'effective_price' => (float) $this->effective_price,
            'has_discount' => $this->sale_price !== null && $this->sale_price < $this->price,
            'stock' => $this->stock,
            'in_stock' => $this->stock > 0,
            'manufacture_year' => $this->manufacture_year,
            'manufacturer_warranty_months' => $this->manufacturer_warranty_months,
            'agency_warranty_months' => $this->agency_warranty_months,
            'expert_rating' => $this->expert_rating ? (float) $this->expert_rating : null,
            'sales_count' => $this->display_sales_count,
            'views_count' => $this->display_views_count,
            'is_featured' => $this->is_featured,
            'badges' => $this->whenLoaded('badges', fn() => $this->badges->pluck('badge')),
            'images' => $this->whenLoaded('images', fn() => $this->images->map(fn($i) => [
                'url' => asset('storage/' . $i->path),
                'is_primary' => $i->is_primary,
            ])),
            'primary_image' => $this->whenLoaded('images', fn() => optional($this->images->firstWhere('is_primary', true) ?? $this->images->first(), fn($i) => asset('storage/' . $i->path))),
            'brand' => new BrandResource($this->whenLoaded('brand')),
            'category' => new CategoryResource($this->whenLoaded('category')),
            'tire_spec' => $this->whenLoaded('tireSpec', fn() => $this->tireSpec ? [
                'width' => $this->tireSpec->width,
                'aspect_ratio' => $this->tireSpec->aspect_ratio,
                'rim_diameter' => $this->tireSpec->rim_diameter,
                'load_index' => $this->tireSpec->load_index,
                'speed_rating' => $this->tireSpec->speed_rating,
                'usage_type' => $this->tireSpec->usage_type,
                'runflat' => $this->tireSpec->runflat,
                'size_string' => $this->tireSpec->size_string,
            ] : null),
            'battery_spec' => $this->whenLoaded('batterySpec', fn() => $this->batterySpec ? [
                'voltage' => $this->batterySpec->voltage,
                'ampere_hour' => $this->batterySpec->ampere_hour,
                'cca' => $this->batterySpec->cca,
                'battery_type' => $this->batterySpec->battery_type,
                'terminal_position' => $this->batterySpec->terminal_position,
                'size_code' => $this->batterySpec->size_code,
            ] : null),
        ];
    }
}
