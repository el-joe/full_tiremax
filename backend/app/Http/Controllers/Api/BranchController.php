<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\BranchResource;
use App\Models\Branch;
use App\Support\ApiResponse;

class BranchController extends Controller
{
    public function index()
    {
        $branches = Branch::where('is_active', true)->with('schedules')->get();
        return ApiResponse::success(BranchResource::collection($branches));
    }
}
