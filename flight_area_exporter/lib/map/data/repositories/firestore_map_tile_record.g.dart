// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_map_tile_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FirestoreMapTileRecord _$$_FirestoreMapTileRecordFromJson(
        Map<String, dynamic> json) =>
    _$_FirestoreMapTileRecord(
      id: json['id'] as int,
      tileIndex: json['tile_index'] as int,
      name: json['name'] as String,
      tileUri: json['tile_uri'] as String,
      creditText: json['credit_text'] as String,
      licensePageUrl: json['license_page_url'] as String,
      enabled: json['enabled'] as bool,
      defaultTile: json['default_tile'] as bool,
      createdAt: json['created_at'] == null
          ? null
          : TimestampUtil.dateFromTimestampValue(json['created_at']),
      updatedAt: json['updated_at'] == null
          ? null
          : TimestampUtil.dateFromTimestampValue(json['updated_at']),
      updatedBy: json['updated_by'] as String? ?? null,
    );

Map<String, dynamic> _$$_FirestoreMapTileRecordToJson(
        _$_FirestoreMapTileRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tile_index': instance.tileIndex,
      'name': instance.name,
      'tile_uri': instance.tileUri,
      'credit_text': instance.creditText,
      'license_page_url': instance.licensePageUrl,
      'enabled': instance.enabled,
      'default_tile': instance.defaultTile,
      'created_at': TimestampUtil.timestampFromDateValue(instance.createdAt),
      'updated_at': TimestampUtil.timestampFromDateValue(instance.updatedAt),
      'updated_by': instance.updatedBy,
    };
