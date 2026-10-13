import 'package:flutter/widgets.dart' show Locale;
import 'package:intl/intl.dart';

import '../../l10n/l10n.dart';

/// Current UI language code. Kept in sync with the app locale by
/// `TireMaxApp` so non-widget helpers (price/time formatting, status labels)
/// follow the same language as `x-locale`.
String appLanguageCode = 'en';

AppLocalizations get currentL10n => lookupAppLocalizations(Locale(appLanguageCode));

final _grouped = NumberFormat('#,##0.##', 'en');

/// Web `value.toLocaleString()` (en grouping).
String formatNumber(num value) => _grouped.format(value);

/// Web price rendering: `{value.toLocaleString()}{t("iqd")}`.
String formatIqd(num value) => '${formatNumber(value)} ${currentL10n.iqdLabel}';

/// Date/time pattern formatted in the active UI language (web `Intl` / `toLocale*`).
String formatDateLocalized(String pattern, DateTime date) => DateFormat(pattern, appLanguageCode).format(date);

/// Localized label for a raw API order/booking status (falls back to the raw value).
String statusLabel(String status) {
  final l = currentL10n;
  switch (status) {
    case 'pending':
      return l.statusPending;
    case 'confirmed':
      return l.statusConfirmed;
    case 'processing':
      return l.processing;
    case 'on_the_way':
      return l.onTheWay;
    case 'delivered':
      return l.delivered;
    case 'cancelled':
    case 'canceled':
      return l.cancelled;
    case 'complete':
    case 'completed':
      return l.statusComplete;
    case 'rescheduled':
      return l.statusRescheduled;
    case 'paid':
      return l.statusPaid;
    case 'failed':
      return l.statusFailed;
    default:
      return status;
  }
}

/// Web `normalizeIraqiPhone` (mirrors backend `App\Support\Phone`).
String normalizeIraqiPhone(String phone) {
  var digits = phone.replaceAll(RegExp(r'\D+'), '');
  if (digits.startsWith('00964')) digits = digits.substring(2);
  if (digits.startsWith('964')) return digits;
  if (digits.startsWith('0')) return '964${digits.substring(1)}';
  if (digits.length == 10 && digits[0] == '7') return '964$digits';
  return digits;
}

/// Web `isValidIraqiPhone`.
bool isValidIraqiPhone(String phone) => RegExp(r'^9647\d{9}$').hasMatch(normalizeIraqiPhone(phone));

String _formatClock(String time) {
  final parts = time.split(':');
  final h = int.tryParse(parts.first) ?? 0;
  final m = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
  final h12 = h % 12 == 0 ? 12 : h % 12;
  final l = currentL10n;
  final digits = appLanguageCode == 'ar' ? NumberFormat('00', 'ar') : NumberFormat('00', 'en');
  final hh = appLanguageCode == 'ar' ? NumberFormat('0', 'ar').format(h12) : '$h12';
  return '$hh:${digits.format(m)} ${h >= 12 ? l.timePm : l.timeAm}';
}

/// Web `helpers/formatTimeRange`: `9:00 AM - 10:00 PM` (null when missing).
String? formatTimeRange(String? opensAt, String? closesAt) {
  if (opensAt == null || closesAt == null || opensAt.isEmpty || closesAt.isEmpty) return null;
  return '${_formatClock(opensAt)} - ${_formatClock(closesAt)}';
}
