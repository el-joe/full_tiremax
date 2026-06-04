<?php

namespace App\Support;

use Illuminate\Auth\AuthenticationException;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\JsonResponse;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpKernel\Exception\HttpException;
use Symfony\Component\HttpKernel\Exception\HttpExceptionInterface;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Throwable;
use Tymon\JWTAuth\Exceptions\JWTException;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions\TokenInvalidException;

class ApiException
{
    public static function handle(Throwable $e): JsonResponse
    {
        if ($e instanceof ValidationException) {
            return ApiResponse::validation($e->errors(), __('messages.validation_failed'));
        }

        if ($e instanceof AuthenticationException) {
            return ApiResponse::unauthorized(__('messages.unauthenticated'));
        }

        if ($e instanceof TokenExpiredException) {
            return ApiResponse::unauthorized(__('messages.token_expired'));
        }

        if ($e instanceof TokenInvalidException) {
            return ApiResponse::unauthorized(__('messages.token_invalid'));
        }

        if ($e instanceof JWTException) {
            return ApiResponse::unauthorized($e->getMessage());
        }

        if ($e instanceof ModelNotFoundException || $e instanceof NotFoundHttpException) {
            return ApiResponse::notFound(__('messages.not_found'));
        }

        if ($e instanceof HttpExceptionInterface) {
            return ApiResponse::error($e->getMessage() ?: __('messages.error'), $e->getStatusCode());
        }

        $debug = config('app.debug');
        return ApiResponse::error(
            $debug ? $e->getMessage() : __('messages.server_error'),
            500,
            $debug ? ['trace' => collect($e->getTrace())->take(5)] : null
        );
    }

    public static function badRequest(string $message): HttpException
    {
        return new HttpException(400, $message);
    }

    public static function unauthorized(string $message = 'Unauthorized'): HttpException
    {
        return new HttpException(401, $message);
    }

    public static function forbidden(string $message = 'Forbidden'): HttpException
    {
        return new HttpException(403, $message);
    }

    public static function notFound(string $message = 'Not Found'): HttpException
    {
        return new HttpException(404, $message);
    }
}
