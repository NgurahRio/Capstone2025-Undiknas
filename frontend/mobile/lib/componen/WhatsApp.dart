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

  final Uri waUri = Uri.parse('https://wa.me/$cleaned');
  final Uri telUri = Uri(scheme: 'tel', path: '+$cleaned');

  try {
    bool canLaunchWA = await canLaunchUrl(waUri);
    if (canLaunchWA) {
      await launchUrl(waUri, mode: LaunchMode.externalApplication);
      debugPrint("✅ Membuka WhatsApp: $cleaned");
    } else {
      await launchUrl(telUri, mode: LaunchMode.externalApplication);
      debugPrint("☎️ Membuka panggilan ke: +$cleaned");
    }
  } catch (e) {
    debugPrint('❌ Gagal membuka WhatsApp/telepon: $e');
  }
}
