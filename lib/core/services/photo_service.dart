import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class PhotoService {
  PhotoService._();

  /// Pick up to [max] images, compress them and upload to Supabase Storage.
  /// Returns a list of public URLs.
  static Future<List<String>> pickAndUploadPhotos({
    int max = 3,
    int quality = 70,
  }) async {
    final picker = ImagePicker();

    final List<XFile>? picked = await picker.pickMultiImage(
      limit: max,
      imageQuality: 100,
    );

    if (picked == null || picked.isEmpty) return <String>[];

    final client = Supabase.instance.client;
    final bucket = client.storage.from('photos');

    final urls = <String>[];
    for (final xfile in picked) {
      final path = xfile.path;
      if (path.isEmpty) continue;

      final compressedDir = await Directory.systemTemp.createTemp();
      final compressedPath = '${compressedDir.path}/${Uuid().v4()}.jpg';

      final XFile? compressedFilePath = await FlutterImageCompress.compressAndGetFile(
        path,
        compressedPath,
        quality: quality,
      );

      if (compressedFilePath == null) continue;

      final fileBytes = await File(compressedFilePath.path).readAsBytes();

      final fileName = 'commerces/${Uuid().v4()}.jpg';

      await bucket.uploadBinary(
        fileName,
        fileBytes,
        fileOptions: const FileOptions(
          contentType: 'image/jpeg',
          cacheControl: '3600',
        ),
      );

      urls.add(bucket.getPublicUrl(fileName));
    }

    return urls;
  }
}
