<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\StoreContactMessageRequest;
use App\Models\ContactMessage;
use App\Support\ApiResponse;

class ContactMessageController extends Controller
{
    public function store(StoreContactMessageRequest $request)
    {
        ContactMessage::create([
            ...$request->validated(),
            'customer_id' => $request->user()?->id,
            'status' => ContactMessage::STATUS_NEW,
            'ip_address' => $request->ip(),
        ]);

        return ApiResponse::created(null, __('messages.contact_message_sent'));
    }
}
