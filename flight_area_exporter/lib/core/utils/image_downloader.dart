import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' show AnchorElement;

class ImageDownloader {
  const ImageDownloader._();

  static void downloadBytes(String filename, Uint8List imageBytes) {
    const mimeType = 'image/jpeg';

    final base64bytes = base64Encode(imageBytes);

    final anchor = AnchorElement();
    anchor.href = 'data:$mimeType;base64,$base64bytes';
    anchor.download = filename;
    anchor.click();
  }
}
