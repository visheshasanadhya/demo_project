import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:universal_html/html.dart' as html;

class DownloadUtil {
  static Future<void> downloadPoster(
    BuildContext context,
    ScreenshotController controller,
  ) async {
    final image = await controller.capture();
    if (image == null) return;

    if (kIsWeb) {
      final blob = html.Blob([image]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'poster.png')
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      if (await Permission.storage.request().isGranted) {
        final directory = await getApplicationDocumentsDirectory();
        final path =
            '${directory.path}/poster_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = io.File(path);
        await file.writeAsBytes(image);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Poster saved at $path')));
      }
    }
  }
}
