import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/timestamp_util.dart';
import '../../domain/repositories/map_tile_record.dart';

part 'map_tile_info.freezed.dart';
part 'map_tile_info.g.dart';

@freezed
class MapTileInfo with _$MapTileInfo implements MapTileRecord {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory MapTileInfo({
    required int id,
    required int tileIndex,
    required String name,
    required String tileUri,
    required String creditText,
    required String licensePageUrl,
    required bool enabled,
    required bool defaultTile,
    @Default(null) @timestampJsonKey DateTime? createdAt,
    @Default(null) @timestampJsonKey DateTime? updatedAt,
    @Default(null) String? updatedBy,
  }) = _MapTileInfo;

  const MapTileInfo._();

  factory MapTileInfo.fromJson(Map<String, dynamic> json) =>
      _$MapTileInfoFromJson(json);

  factory MapTileInfo.fromRecord(MapTileRecord record) {
    return MapTileInfo(
        id: record.id,
        tileIndex: record.tileIndex,
        name: record.name,
        tileUri: record.tileUri,
        creditText: record.creditText,
        licensePageUrl: record.licensePageUrl,
        enabled: record.enabled,
        defaultTile: record.defaultTile);
  }

  bool get isEnabled => enabled;
  bool get isDisabled => !enabled;

  bool get isDefaultTile => defaultTile;
}
