import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';

/// Mirrors `frontend/helpers/getPublicSettings.ts` (`GET /settings/public`).
class PublicSettings {
  const PublicSettings({
    this.whatsappUrl = '',
    this.whatsappButtonEnabled = false,
    this.sitePhone = '',
    this.siteEmail = '',
    this.address = '',
  });

  final String whatsappUrl;
  final bool whatsappButtonEnabled;
  final String sitePhone;
  final String siteEmail;
  final String address;

  bool get showWhatsapp => whatsappButtonEnabled && whatsappUrl.isNotEmpty;

  factory PublicSettings.fromJson(Map<String, dynamic> json) {
    final enabled = json['whatsapp_button_enabled'];
    return PublicSettings(
      whatsappUrl: (json['whatsapp_url'] as String?)?.trim() ?? '',
      whatsappButtonEnabled:
          enabled == true || enabled == 1 || enabled == '1' || enabled == 'true',
      sitePhone: (json['site_phone'] as String?)?.trim() ?? '',
      siteEmail: (json['site_email'] as String?)?.trim() ?? '',
      address: (json['address'] as String?)?.trim() ?? '',
    );
  }
}

final publicSettingsProvider = FutureProvider<PublicSettings>((ref) async {
  try {
    final response = await ref.watch(apiClientProvider).get('settings/public');
    final body = response.data;
    final data = body is Map<String, dynamic> && body['data'] is Map<String, dynamic>
        ? body['data'] as Map<String, dynamic>
        : (body is Map<String, dynamic> ? body : <String, dynamic>{});
    return PublicSettings.fromJson(data);
  } on DioException {
    return const PublicSettings();
  }
});
