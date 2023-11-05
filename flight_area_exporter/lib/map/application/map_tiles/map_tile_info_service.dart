import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/logger.dart';
import '../../domain/repositories/map_tile_repository.dart';
import 'map_tile_info.dart';

part 'map_tile_info_service.g.dart';

@Riverpod(keepAlive: true)
MapTileInfoService mapTileInfoService(Ref ref) =>
    throw UnimplementedError('should override mapTileInfoServiceProvider.');

class MapTileInfoService {
  factory MapTileInfoService({required MapTileRepository repository}) {
    return MapTileInfoService._(repository, [], Completer<bool>())
      .._initialize();
  }

  const MapTileInfoService._(this._repository, this._tiles, this._initialized);

  final MapTileRepository _repository;
  final List<MapTileInfo> _tiles;
  List<MapTileInfo> get tiles => _tiles;

  final Completer<bool> _initialized;
  Future<bool> get isInitialized => _initialized.future;

  Future<void> _initialize() async {
    final completer = Completer<List<MapTileInfo>>();
    final subsc = _repository.watchTiles().listen((event) {
      if (event.isNotEmpty) {
        completer.complete(
          event.map((e) => MapTileInfo.fromRecord(e)).toList(),
        );
      }
    });
    late final List<MapTileInfo> tiles;
    try {
      tiles = await completer.future.timeout(const Duration(seconds: 20));
    } catch (e) {
      tiles = [
        MapTileInfo.fromRecord(_repository.getInfoForFailSafe()),
      ];
    } finally {
      await subsc.cancel();
    }

    final tileLog = tiles
        .map<String>(
            (e) => 'name=${e.name}, uri=${e.tileUri}, by ${e.updatedBy}')
        .join('\n');
    logger.i('[Main] MapTileInfos initialized. \n$tileLog');

    _tiles.cast();
    _tiles.addAll(tiles);

    _initialized.complete(true);
  }
}

final defaultTileInfoProvider = Provider<MapTileInfo>(
  (ref) {
    return ref.watch(
      mapTileInfoServiceProvider.select(
        (service) {
          final tiles = service.tiles;
          return tiles.singleWhere((e) => e.isEnabled && e.isDefaultTile,
              orElse: () => tiles.first);
        },
      ),
    );
  },
);
