<?php

namespace App\Support;

class Phone
{
    /** Normalise an Iraqi phone number to 9647XXXXXXXXX (digits only). Returns null when empty. */
    public static function normalize(?string $phone): ?string
    {
        if ($phone === null) {
            return null;
        }
        $digits = preg_replace('/\D+/', '', $phone);
        if ($digits === '' || $digits === null) {
            return null;
        }
        if (str_starts_with($digits, '00964')) {
            $digits = substr($digits, 2);
        }
        if (str_starts_with($digits, '964')) {
            return $digits;
        }
        if (str_starts_with($digits, '0')) {
            return '964' . substr($digits, 1);
        }
        if (strlen($digits) === 10 && $digits[0] === '7') {
            return '964' . $digits;
        }
        return $digits;
    }

    public static function isValidIraqi(?string $phone): bool
    {
        $n = self::normalize($phone);
        return $n !== null && (bool) preg_match('/^9647\d{9}$/', $n);
    }
}
