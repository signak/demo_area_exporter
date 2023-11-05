import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/timestamp_util.dart';
import '../../domain/repositories/map_tile_record.dart';

part 'firestore_map_tile_record.freezed.dart';
part 'firestore_map_tile_record.g.dart';

@freezed
class FirestoreMapTileRecord
    with _$FirestoreMapTileRecord
    implements MapTileRecord {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory FirestoreMapTileRecord({
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
  }) = _FirestoreMapTileRecord;

  const FirestoreMapTileRecord._();

  factory FirestoreMapTileRecord.fromJson(Map<String, dynamic> json) =>
      _$FirestoreMapTileRecordFromJson(json);
}
