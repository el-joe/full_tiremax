import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Page scaffold for the mobile design: light [AppColors.page] background,
/// compact dark app bar (back arrow auto-mirrors in RTL), SafeArea body.
///
/// Pass [slivers] for scroll views (e.g. a large-title [SliverAppBar]) instead
/// of [body]; then [title] is ignored. [bottomBar] is typically a
/// [StickyBottomBar].
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.title,
    this.body,
    this.actions,
    this.bottomBar,
    this.showAppBar = true,
    this.resizeToAvoidBottomInset = true,
  });

  final String? title;
  final Widget? body;
  final List<Widget>? actions;
  final Widget? bottomBar;
  final bool showAppBar;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.page,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: showAppBar
          ? AppBar(
              backgroundColor: AppColors.chrome,
              foregroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              title: title == null
                  ? null
                  : Text(
                      title!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
              actions: actions,
            )
          : null,
      body: body == null
          ? null
          : SafeArea(top: !showAppBar, bottom: bottomBar == null, child: body!),
      bottomNavigationBar: bottomBar,
    );
  }
}

/// Large-title collapsing dark app bar for Home/Store scroll views.
class LargeTitleSliverAppBar extends StatelessWidget {
  const LargeTitleSliverAppBar({
    super.key,
    required this.title,
    this.actions,
    this.bottom,
  });

  final String title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      centerTitle: true,
      backgroundColor: AppColors.chrome,
      foregroundColor: Colors.white,
      scrolledUnderElevation: 0,
      actions: actions,
      bottom: bottom,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Section title (16/700) with an optional "See all" action.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;

  /// Localized "See all" text; the action is hidden when null.
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.gutter,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.foregroundLight,
              ),
            ),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                minimumSize: const Size(AppSpacing.minTap, AppSpacing.minTap),
              ),
              child: Text(
                actionLabel!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// White 16px-radius card with a subtle shadow; tappable when [onTap] is set.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: radius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Bottom bar showing a total ([label] + [value]) and a CTA ([action], usually
/// a [PrimaryButton]). Use as `AppScaffold.bottomBar` on product, cart,
/// checkout and reservation screens. Keyboard/safe-area aware.
class StickyBottomBar extends StatelessWidget {
  const StickyBottomBar({
    super.key,
    this.label,
    this.value,
    required this.action,
  });

  final String? label;
  final Widget? value;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.md,
            AppSpacing.gutter,
            AppSpacing.md,
          ),
          child: Row(
            children: [
              if (label != null || value != null) ...[
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (label != null)
                        Text(
                          label!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.gray2,
                          ),
                        ),
                      ?value,
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
              ],
              Expanded(flex: 3, child: action),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet body: drag handle, optional title, scrollable [child] and an
/// optional sticky [actionBar]. Show with [showAppBottomSheet].
class BottomSheetScaffold extends StatelessWidget {
  const BottomSheetScaffold({
    super.key,
    this.title,
    required this.child,
    this.actionBar,
  });

  final String? title;
  final Widget child;
  final Widget? actionBar;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            if (title != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  AppSpacing.md,
                  AppSpacing.gutter,
                  AppSpacing.sm,
                ),
                child: Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.foregroundLight,
                  ),
                ),
              ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.gutter),
                child: child,
              ),
            ),
            if (actionBar != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  0,
                  AppSpacing.gutter,
                  AppSpacing.md,
                ),
                child: actionBar,
              ),
          ],
        ),
      ),
    );
  }
}

/// Shows [builder]'s content in a rounded, scroll-controlled modal sheet
/// (light theme surface) and returns its result.
Future<T?> showAppBottomSheet<T>(BuildContext context, WidgetBuilder builder) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: builder,
  );
}
