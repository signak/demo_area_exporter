import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/map_tiles/map_tile_info.dart';
import '../../application/map_tiles/map_tile_info_service.dart';
import '../controllers/home_screen_controller.dart';

class TileSelectDropDown extends ConsumerWidget {
  const TileSelectDropDown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapTileInfoService = ref.watch(mapTileInfoServiceProvider);
    final tiles = mapTileInfoService.tiles;
    final tileInfo = ref.watch(currentTileInfoProvider);

    return DropdownButton<MapTileInfo>(
      value: tileInfo,
      items: tiles
          .map(
            (info) => DropdownMenuItem<MapTileInfo>(
              value: info,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(info.name),
              ),
            ),
          )
          .toList(),
      onChanged: (info) {
        if (info != null) {
          ref.read(currentTileInfoProvider.notifier).update((state) => info);
        }
      },
    );
  }
}
