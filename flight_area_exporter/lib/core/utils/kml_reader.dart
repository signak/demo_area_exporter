import 'package:latlong2/latlong.dart';
import 'package:xml/xml.dart';

import 'logger.dart';

class KmlReader {
  static Future<Map<String, List<LatLng>>> loadKML(String kmlString) async {
    logger.d(
        "============================LOAD KML==============================");

    final data = await _parseKML(kmlString);
    return Map.fromIterables(
        data.map((e) => e.id),
        data.map(
          (e) => e.coordinates,
        ));
  }

  static List<LatLng> _convertLatLng(String? coordinates) {
    final ret = <LatLng>[];
    if (coordinates == null) {
      return <LatLng>[];
    }

    final fixedCoord = coordinates.replaceAll(RegExp(r'\s+'), ' ').trim();
    for (final data in fixedCoord.split(' ')) {
      final tmp = data.split(',');
      if (tmp.length >= 2) {
        final lat = tmp[1];
        final lng = tmp[0];
        ret.add(LatLng(double.parse(lat), double.parse(lng)));
      }
    }

    return ret;
  }

  static Future<List<_PlaceMark>> _parseKML(String data) async {
    final doc = XmlDocument.parse(data).rootElement;
    if (doc.name.toString() != 'kml') {
      throw ("ERROR: the file is not a KML compatible file");
    }

    List<_PlaceMark> ret = [];
    int noIdCount = 0;
    final pms = doc.findAllElements("Placemark");
    for (final pm in pms) {
      final polys = pm.findAllElements('Polygon');
      for (final p in polys) {
        final id = p.getAttribute('id') ?? 'NO_ID_POLYGON_${noIdCount++}';
        final coordinates = p.findAllElements('coordinates');
        for (final c in coordinates) {
          ret.add(_PlaceMark(id: id, coordinates: _convertLatLng(c.innerText)));
        }
      }

      // cont++;
      // String? name = element.getElement('name')?.value;
      // if (!valid) {
      //   ret.add(_PlaceMark(
      //     id: "Placemark$cont",
      //     name: name,
      //     altitudeMode: altitudeMode,
      //     coordinates: [],
      //     valid: false,
      //   ));
      // } else {
      //   List<LatLng> points = [];
      //   final coordinates =
      //       element.findAllElements('coordinates').first.text.trim().split(' ');
      //   coordinates.forEach((element) {
      //     final dat = element.toString().split(",");
      //     double lat = double.parse(dat[1].toString());
      //     double lng = double.parse(dat[0].toString());
      //     points.add(LatLng(lat, lng));
      //   });
      //   ret.add(_PlaceMark(
      //     id: "Placemark$cont",
      //     name: name,
      //     altitudeMode: altitudeMode,
      //     coordinates: points,
      //   ));
      // }
    }
    return ret;
  }
}

class _PlaceMark {
  String id;
  List<LatLng> coordinates;
  _PlaceMark({
    required this.id,
    required this.coordinates,
  });
}
