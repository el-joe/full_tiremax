import 'package:dio/dio.dart';
import '../../../core/utils/format.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';

/// Mirrors `frontend/Schemas/contactSchema.ts`. Returns an error message
/// (English copy from `home.*` in locale/en.json) or null when valid.
class ContactValidator {
  static String? name(String v) {
    final t = v.trim();
    if (t.isEmpty) return currentL10n.nameRequired;
    if (t.length > 120) return currentL10n.nameMax120;
    return null;
  }

  static String? phone(String v) {
    final t = v.trim();
    if (t.isEmpty) return currentL10n.phoneRequired;
    if (t.length > 30) return currentL10n.phoneMax30;
    return null;
  }

  static String? subject(String v) {
    final t = v.trim();
    if (t.isEmpty) return currentL10n.subjectRequired;
    if (t.length > 190) return currentL10n.subjectMax190;
    return null;
  }

  static String? message(String v) {
    final t = v.trim();
    if (t.isEmpty) return currentL10n.messageRequired;
    if (t.length > 5000) return currentL10n.messageMax5000;
    return null;
  }
}

/// `POST contact-messages` (web `ContactUsForm`).
class ContactRepository {
  ContactRepository(this._dio);

  final Dio _dio;

  Future<void> sendMessage({
    required String name,
    required String phone,
    required String subject,
    required String message,
  }) async {
    await _dio.post('contact-messages', data: {
      'name': name.trim(),
      'phone': phone.trim(),
      'subject': subject.trim(),
      'message': message.trim(),
    });
  }
}

final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  return ContactRepository(ref.watch(apiClientProvider));
});
