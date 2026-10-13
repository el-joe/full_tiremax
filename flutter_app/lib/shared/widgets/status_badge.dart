import 'package:flutter/material.dart';

import '../../core/utils/format.dart';
import '../../core/theme/app_colors.dart';

/// Where a status badge is rendered; the web uses different colours per page.
enum StatusBadgeKind {
  /// `profile/orders/OrdersList` + `RecentOrdersCard`: blue on light blue.
  orderList,

  /// `profile/orders/OrderSummary`: primary on translucent primary.
  orderDetail,

  /// `profile/reservation/ReservationList`: gray when `complete`, else blue.
  bookingList,

  /// `profile/reservation/ReservationSummary`: complete gray, cancelled red,
  /// else primary.
  bookingDetail,

  /// `profile/RecentOrdersCard`: Chakra `colorPalette="green"`.
  recentOrder,
}

(Color fg, Color bg) statusBadgeColors(StatusBadgeKind kind, String status) {
  const blue = Color(0xFF1447E6);
  const blueBg = Color(0xFFDBEAFE);
  const primaryBg = Color(0x33FFB800);
  switch (kind) {
    case StatusBadgeKind.recentOrder:
      return (const Color(0xFF166534), const Color(0xFFDCFCE7));
    case StatusBadgeKind.orderList:
      return (blue, blueBg);
    case StatusBadgeKind.orderDetail:
      return (AppColors.primary, primaryBg);
    case StatusBadgeKind.bookingList:
      return status == 'complete'
          ? (AppColors.gray2, AppColors.gray4)
          : (blue, blueBg);
    case StatusBadgeKind.bookingDetail:
      if (status == 'complete') return (AppColors.gray2, AppColors.gray4);
      if (status == 'cancelled')
        return (const Color(0xFFE7000B), const Color(0xFFFFE2E2));
      return (AppColors.primary, primaryBg);
  }
}

/// Web `Badge` showing the raw API status string (the web does not translate
/// or re-case it).
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status, required this.kind});

  final String status;
  final StatusBadgeKind kind;

  @override
  Widget build(BuildContext context) {
    final (fg, bg) = statusBadgeColors(kind, status);
    final detail =
        kind == StatusBadgeKind.orderDetail ||
        kind == StatusBadgeKind.bookingDetail;
    return Container(
      padding: detail
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 7)
          : const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(detail ? 12 : 10),
      ),
      child: Text(
        statusLabel(status),
        style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}
