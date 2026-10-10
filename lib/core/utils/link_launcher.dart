import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkLauncher {
  LinkLauncher._();

  static Future<void> open(BuildContext context, Uri uri) async {
    final messenger = ScaffoldMessenger.of(context);
    var ok = false;
    try {
      ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      ok = false;
    }
    if (!ok) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not open this link on your device.')),
      );
    }
  }

  static Future<void> openUrl(BuildContext context, String url) =>
      open(context, Uri.parse(url));

  static Future<void> call(BuildContext context, String phone) =>
      open(context, Uri(scheme: 'tel', path: phone));

  static Future<void> email(BuildContext context, String address) =>
      open(context, Uri(scheme: 'mailto', path: address));

  /// mailto with a prefilled subject/body (spaces encoded as %20, not '+').
  static Future<void> emailWith(
    BuildContext context,
    String address, {
    required String subject,
    String body = '',
  }) =>
      open(
        context,
        Uri(
          scheme: 'mailto',
          path: address,
          query: 'subject=${Uri.encodeComponent(subject)}'
              '&body=${Uri.encodeComponent(body)}',
        ),
      );

  static Future<void> map(BuildContext context, String address) => open(
        context,
        Uri.https('www.google.com', '/maps/search/', {
          'api': '1',
          'query': address,
        }),
      );
}
