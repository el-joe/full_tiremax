import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/auth_sheet.dart';
import '../../features/auth/providers/auth_provider.dart';

/// Dart equivalent of the web's `protectedWithAuth`: runs [action] if the
/// user is logged in, otherwise opens the auth sheet.
Future<void> requireAuth(
  BuildContext context,
  WidgetRef ref,
  VoidCallback action,
) async {
  final isLoggedIn = ref.read(isLoggedInProvider);
  if (isLoggedIn) {
    action();
    return;
  }
  await showAuthSheet(context);
}
