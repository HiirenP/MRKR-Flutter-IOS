import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageCompressUtil {
  static const int maxUploadDimension = 1280;
  static const int profileMaxDimension = 512;
  static const int defaultQuality = 82;

  static Future<String> compressForUpload(
    String sourcePath, {
    int maxDimension = maxUploadDimension,
    int quality = defaultQuality,
  }) async {
    if (sourcePath.isEmpty || !File(sourcePath).existsSync()) {
      return sourcePath;
    }

    try {
      final dir = await getTemporaryDirectory();
      final targetPath = p.join(
        dir.path,
        'upload_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        sourcePath,
        targetPath,
        quality: quality,
        minWidth: maxDimension,
        minHeight: maxDimension,
        format: CompressFormat.jpeg,
        keepExif: false,
      );

      return result?.path ?? sourcePath;
    } catch (e) {
      debugPrint('ImageCompressUtil.compressForUpload: $e');
      return sourcePath;
    }
  }

  static Future<String> compressProfile(String sourcePath) {
    return compressForUpload(sourcePath, maxDimension: profileMaxDimension);
  }

  static Future<MultipartFile> multipartFromCompressed(
    String sourcePath, {
    int maxDimension = maxUploadDimension,
    String? filename,
  }) async {
    final compressedPath = await compressForUpload(sourcePath, maxDimension: maxDimension);
    final name = filename ?? p.basename(compressedPath);
    return MultipartFile.fromFile(
      compressedPath,
      filename: name.endsWith('.jpg') ? name : '$name.jpg',
    );
  }
}
