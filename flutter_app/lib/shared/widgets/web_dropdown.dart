import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Labelled select mirroring web `DropSelectList` (label above, rounded
/// bordered trigger, placeholder, loading/empty -> disabled).
class WebDropdown<T> extends StatelessWidget {
  const WebDropdown({
    super.key,
    required this.label,
    required this.placeholder,
    required this.items,
    required this.value,
    required this.onChanged,
    this.isLoading = false,
    this.radius = 12,
  });

  final String? label;
  final String placeholder;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final bool isLoading;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: const BorderSide(color: AppColors.gray),
    );
    final hasValue = items.any((e) => e.value == value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.foregroundLight)),
          const SizedBox(height: 6),
        ],
        DropdownButtonFormField<T>(
          key: ValueKey('${label}_${hasValue ? value : null}_${items.length}'),
          initialValue: hasValue ? value : null,
          isExpanded: true,
          icon: isLoading
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.keyboard_arrow_down),
          dropdownColor: Colors.white,
          style: const TextStyle(fontSize: 14, color: AppColors.foregroundLight),
          hint: Text(placeholder, style: const TextStyle(fontSize: 14, color: AppColors.gray2)),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: border,
            enabledBorder: border,
            disabledBorder: border,
            focusedBorder: border.copyWith(borderSide: const BorderSide(color: AppColors.primary)),
          ),
          items: items,
          onChanged: items.isEmpty || isLoading ? null : onChanged,
        ),
      ],
    );
  }
}
