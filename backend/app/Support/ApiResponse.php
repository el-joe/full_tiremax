<?php

namespace App\Support;

use Illuminate\Http\JsonResponse;

class ApiResponse
{
    public static function success(mixed $data = null, ?string $message = null, int $status = 200, array $meta = []): JsonResponse
    {
        return response()->json(array_filter([
            'success' => true,
            'message' => $message ?? __('messages.success'),
            'data' => $data,
            'meta' => $meta ?: null,
        ], fn($v) => $v !== null), $status);
    }

    public static function created(mixed $data = null, ?string $message = null): JsonResponse
    {
        return self::success($data, $message ?? __('messages.created'), 201);
    }

    public static function error(string $message, int $status = 400, array|null $errors = null): JsonResponse
    {
        return response()->json(array_filter([
            'success' => false,
            'message' => $message,
            'errors' => $errors,
        ], fn($v) => $v !== null), $status);
    }

    public static function validation(array $errors, ?string $message = null): JsonResponse
    {
        return self::error($message ?? __('messages.validation_failed'), 422, $errors);
    }

    public static function unauthorized(?string $message = null): JsonResponse
    {
        return self::error($message ?? __('messages.unauthenticated'), 401);
    }

    public static function forbidden(?string $message = null): JsonResponse
    {
        return self::error($message ?? __('messages.forbidden'), 403);
    }

    public static function notFound(?string $message = null): JsonResponse
    {
        return self::error($message ?? __('messages.not_found'), 404);
    }
}
