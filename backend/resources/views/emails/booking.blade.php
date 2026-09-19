<x-mail::message>
<div dir="{{ $rtl ? 'rtl' : 'ltr' }}" style="text-align: {{ $rtl ? 'right' : 'left' }}">

{{ __('emails.hello', ['name' => $booking->customer_name], $loc) }}

{{ __('emails.' . $kind . '.intro', [], $loc) }}

**{{ __('emails.reference', [], $loc) }}:** {{ $booking->reference }}
**{{ __('emails.status', [], $loc) }}:** {{ __('emails.statuses.' . $booking->status, [], $loc) }}
**{{ __('emails.service', [], $loc) }}:** {{ optional($booking->service?->translate($loc))->name }}
**{{ __('emails.date', [], $loc) }}:** {{ $booking->scheduled_at->format('Y-m-d H:i') }}
@if ($booking->branch)
**{{ __('emails.branch', [], $loc) }}:** {{ optional($booking->branch->translate($loc))->name ?? $booking->branch->code }}
@endif

<x-mail::button :url="config('app.frontend_url') . '/' . $loc . '/profile/bookings'">
{{ __('emails.view_booking', [], $loc) }}
</x-mail::button>

@if ($booking->is_guest || !$booking->customer_id)
{{ __('emails.guest_cta', [], $loc) }}

<x-mail::button :url="config('app.frontend_url') . '/' . $loc . '/?authDialog=on&phone=' . urlencode($booking->customer_phone)" color="success">
{{ __('emails.guest_cta_button', [], $loc) }}
</x-mail::button>
@endif

{{ __('emails.thanks', [], $loc) }}<br>
{{ $siteName }}
</div>
</x-mail::message>
