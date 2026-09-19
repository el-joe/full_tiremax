import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/app_localizations.dart';
import '../data/public_settings_repository.dart';

/// Green floating WhatsApp button, hidden when disabled or without a URL.
class WhatsappFab extends ConsumerWidget {
  const WhatsappFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(publicSettingsProvider).value;
    if (settings == null || !settings.showWhatsapp) return const SizedBox.shrink();
    final uri = Uri.tryParse(settings.whatsappUrl);
    if (uri == null) return const SizedBox.shrink();
    final tooltip = AppLocalizations.of(context).whatsappChat;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: const Color(0xFF25D366),
        shape: const CircleBorder(),
        elevation: 6,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => launchUrl(uri, mode: LaunchMode.externalApplication),
          child: const Padding(
            padding: EdgeInsets.all(14),
            child: Icon(Icons.chat, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}
