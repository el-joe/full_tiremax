import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Numbered pagination mirroring web `components/ui/Pagination.tsx`
/// (40x40 gray-4 buttons, selected = primary, prev/next arrows).
class WebPagination extends StatelessWidget {
  const WebPagination({super.key, required this.current, required this.last, required this.onPage});

  final int current;
  final int last;
  final ValueChanged<int> onPage;

  List<int?> _pages() {
    // 1 ... c-1 c c+1 ... last  (null = ellipsis)
    final set = <int>{1, last, current - 1, current, current + 1}..removeWhere((p) => p < 1 || p > last);
    final sorted = set.toList()..sort();
    final out = <int?>[];
    for (var i = 0; i < sorted.length; i++) {
      if (i > 0 && sorted[i] - sorted[i - 1] > 1) out.add(null);
      out.add(sorted[i]);
    }
    return out;
  }

  Widget _btn(Widget child, {VoidCallback? onTap, bool selected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.gray4,
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (last <= 1) return const SizedBox.shrink();
    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 6,
      children: [
        _btn(const Icon(Icons.arrow_back, size: 18, color: Colors.black), onTap: current > 1 ? () => onPage(current - 1) : null),
        for (final p in _pages())
          p == null
              ? _btn(const Text('…', style: TextStyle(color: Colors.black)))
              : _btn(
                  Text('$p', style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
                  selected: p == current,
                  onTap: () => onPage(p),
                ),
        _btn(const Icon(Icons.arrow_forward, size: 18, color: Colors.black), onTap: current < last ? () => onPage(current + 1) : null),
      ],
    );
  }
}
