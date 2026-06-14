import 'package:flutter/foundation.dart';
import 'package:marker/app/global/app_config.dart';

/// In local dev the API often returns `http://localhost:3001/...` while the app
/// calls `http://<LAN-IP>:3001`. Rewrite media URLs so images load on device/emulator.
bool get _rewriteLocalMediaUrls =>
    kDebugMode ||
    AppConfig.resolvedApiEnv == 'dev' ||
    AppConfig.resolvedApiEnv == 'staging';

String resolveApiMediaUrl(String? url) {
  if (url == null || url.isEmpty) return '';
  if (!_rewriteLocalMediaUrls) return url;

  final apiOrigin = AppConfig.socketUrl;
  const localOrigins = [
    'http://localhost:3001',
    'http://127.0.0.1:3001',
    'https://localhost:3001',
    'https://127.0.0.1:3001',
  ];

  for (final origin in localOrigins) {
    if (url.startsWith(origin)) {
      return url.replaceFirst(origin, apiOrigin);
    }
  }
  return url;
}

/// Prefer API thumbnail URL for list/grid; fall back to full image URL.
String listImageUrl(String? fullUrl, {String? thumbUrl}) {
  if (thumbUrl != null && thumbUrl.isNotEmpty) {
    return resolveApiMediaUrl(thumbUrl);
  }
  return resolveApiMediaUrl(fullUrl);
}

/// Bar list card: first gallery thumb, else logo thumb, else full URLs.
String barListImageUrl({
  String? logo,
  String? logoThumb,
  List<({String? url, String? urlThumb})>? images,
}) {
  if (images != null && images.isNotEmpty) {
    final first = images.first;
    final thumb = listImageUrl(first.url, thumbUrl: first.urlThumb);
    if (thumb.isNotEmpty) return thumb;
  }
  return listImageUrl(logo, thumbUrl: logoThumb);
}
