import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/home_screen_controller.dart';

class MapLicenseText extends ConsumerWidget {
  const MapLicenseText({super.key});

  static const String _copyrightMark = '© ';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final containerColor = Theme.of(context).colorScheme.surface.withAlpha(200);
    final tileInfo = ref.watch(currentTileInfoProvider);

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            child: Text(
              '$_copyrightMark ${tileInfo.creditText}',
              style: TextStyle(
                color: textColor,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
