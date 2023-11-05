import 'map_tile_record.dart';

abstract class MapTileRepository {
  Stream<List<MapTileRecord>> watchTiles({
    bool includeDisabledInfos = false,
  });

  MapTileRecord getInfoForFailSafe();
}
