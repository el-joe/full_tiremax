<x-mail::message>
<div dir="{{ $rtl ? 'rtl' : 'ltr' }}" style="text-align: {{ $rtl ? 'right' : 'left' }}">

{{ __('emails.hello', ['name' => $order->customer_name], $loc) }}

{{ __('emails.' . $kind . '.intro', [], $loc) }}

**{{ __('emails.reference', [], $loc) }}:** {{ $order->reference }}
**{{ __('emails.status', [], $loc) }}:** {{ __('emails.statuses.' . $order->status, [], $loc) }}

<x-mail::table>
| {{ __('emails.product', [], $loc) }} | {{ __('emails.qty', [], $loc) }} | {{ __('emails.price', [], $loc) }} |
|:--|:-:|--:|
@foreach ($order->items as $item)
| {{ $item->product_name }} | {{ $item->quantity }} | {{ number_format((float) $item->unit_price * $item->quantity) }} |
@endforeach
</x-mail::table>

{{ __('emails.subtotal', [], $loc) }}: {{ number_format((float) $order->subtotal) }} {{ __('emails.currency', [], $loc) }}
@if ((float) $order->shipping_fee > 0)

{{ __('emails.shipping', [], $loc) }}: {{ number_format((float) $order->shipping_fee) }} {{ __('emails.currency', [], $loc) }}
@endif
@if ((float) $order->discount > 0)

{{ __('emails.discount', [], $loc) }}: -{{ number_format((float) $order->discount) }} {{ __('emails.currency', [], $loc) }}
@endif

**{{ __('emails.total', [], $loc) }}: {{ number_format((float) $order->total) }} {{ __('emails.currency', [], $loc) }}**
@if ($order->branch)

**{{ __('emails.branch', [], $loc) }}:** {{ optional($order->branch->translate($loc))->name ?? $order->branch->code }}
@endif
@if ($order->shipping_address)

**{{ __('emails.address', [], $loc) }}:** {{ $order->shipping_address }}
@endif

<x-mail::button :url="config('app.frontend_url') . '/' . $loc . '/profile/orders/' . $order->reference . '?phone=' . urlencode($order->customer_phone)">
{{ __('emails.track_order', [], $loc) }}
</x-mail::button>

@if ($order->is_guest || !$order->customer_id)
{{ __('emails.guest_cta', [], $loc) }}

<x-mail::button :url="config('app.frontend_url') . '/' . $loc . '/?authDialog=on&phone=' . urlencode($order->customer_phone)" color="success">
{{ __('emails.guest_cta_button', [], $loc) }}
</x-mail::button>
@endif

{{ __('emails.thanks', [], $loc) }}<br>
{{ $siteName }}
</div>
</x-mail::message>
