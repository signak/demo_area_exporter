import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';

import '../../../core/utils/image_downloader.dart';

final screenshotControllerProvider = Provider<ScreenshotController>(
  (ref) => ScreenshotController(),
);

class ScreenshotButton extends ConsumerWidget {
  const ScreenshotButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenshotController = ref.watch(screenshotControllerProvider);

    return ElevatedButton.icon(
      onPressed: () {
        screenshotController.capture().then(
          (img) {
            if (img != null) {
              ImageDownloader.downloadBytes("flight_area_map.png", img);
            }
          },
        );
      },
      icon: const Icon(Icons.photo_camera),
      label: const Text('save'),
    );
  }
}
