import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

Future<void> openWhatsApp(String phoneNumber) async {
  String cleaned = phoneNumber
      .replaceAll(' ', '')
      .replaceAll('-', '')
      .replaceAll('(', '')
      .replaceAll(')', '');

  if (cleaned.startsWith('0')) {
    cleaned = '62${cleaned.substring(1)}';
  } else if (cleaned.startsWith('+')) {
    cleaned = cleaned.substring(1);
  }

  final Uri waUri =
      Uri.parse('https://api.whatsapp.com/send?phone=$cleaned');
  final Uri telUri = Uri(scheme: 'tel', path: '+$cleaned');

  try {
    await launchUrl(
      waUri,
      mode: LaunchMode.externalApplication,
    );

    debugPrint("🌐 Dibuka lewat browser → WhatsApp");
  } catch (e) {
    debugPrint('❌ Gagal buka WA, fallback ke telepon: $e');
    await launchUrl(telUri);
  }
}
