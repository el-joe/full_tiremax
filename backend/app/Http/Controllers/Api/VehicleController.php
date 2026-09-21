<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\VehicleMakeResource;
use App\Http\Resources\VehicleModelResource;
use App\Http\Resources\VehicleResource;
use App\Models\Vehicle;
use App\Models\VehicleMake;
use App\Models\VehicleModel;
use App\Services\VehicleService;
use App\Support\ApiResponse;
use Illuminate\Http\Request;

class VehicleController extends Controller
{
    public function __construct(protected VehicleService $service)
    {
    }

    public function makes()
    {
        return ApiResponse::success(VehicleMakeResource::collection($this->service->makes()));
    }

    public function models(VehicleMake $make)
    {
        return ApiResponse::success(VehicleModelResource::collection($this->service->models($make)));
    }

    public function years(VehicleModel $model)
    {
        return ApiResponse::success(VehicleResource::collection($this->service->years($model)));
    }

    public function index(Request $request)
    {
        $q = Vehicle::query()->with(['model.make', 'model.translations', 'translations']);
        if ($request->filled('make_id')) {
            $q->whereHas('model', fn($qb) => $qb->where('vehicle_make_id', $request->make_id));
        }
        if ($request->filled('model_id')) {
            $q->where('vehicle_model_id', $request->model_id);
        }
        if ($request->filled('year')) {
            $q->where('year_from', '<=', $request->year)
                ->where(function ($qb) use ($request) {
                    $qb->whereNull('year_to')->orWhere('year_to', '>=', $request->year);
                });
        }
        return ApiResponse::success(VehicleResource::collection($q->limit(50)->get()));
    }

    public function show(Vehicle $vehicle)
    {
        $vehicle->load(['model.make', 'model.translations', 'translations']);
        return ApiResponse::success(new VehicleResource($vehicle));
    }
}
