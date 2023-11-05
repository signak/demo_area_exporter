import 'package:latlong2/latlong.dart';

class MapViewConstants {
  static const double _initialLatitude = 36.370888159377344;
  static const double _initialLongitude = 140.47618386701245;
  static const LatLng initialLocation =
      LatLng(_initialLatitude, _initialLongitude);
  static const double defaultZoomLevel = 17;
  static const double maxZoomLevel = 19;
  static const double minZoomLevel = 6;
  static const double maxAutoZoomLevel = 17;
  static const double areaStrokeWidth = 8;

  static const double mapWidth = 940;
  static const double mapHeight = 600;
  static const int mapScaleWidth = 300;
}
