abstract class MapTileRecord {
  int get id;
  int get tileIndex;
  String get name;
  String get tileUri;
  String get creditText;
  String get licensePageUrl;
  bool get enabled;
  bool get defaultTile;
  DateTime? get createdAt;
  DateTime? get updatedAt;
  String? get updatedBy;
}
