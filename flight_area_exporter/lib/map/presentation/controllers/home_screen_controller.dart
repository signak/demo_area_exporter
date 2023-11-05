import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../application/map_tiles/map_tile_info.dart';
import '../../application/map_tiles/map_tile_info_service.dart';

final currentTileInfoProvider = StateProvider<MapTileInfo>(
  (ref) => ref.watch(defaultTileInfoProvider),
);

final polygonsProvider = StateProvider<List<List<LatLng>>>(
  (ref) => const [
    [
      LatLng(36.371043, 140.475746),
      LatLng(36.370655, 140.475913),
      LatLng(36.370647, 140.476465),
      LatLng(36.371014, 140.476425),
    ],
  ],
);
