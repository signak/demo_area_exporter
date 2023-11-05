import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/home_screen_controller.dart';
import 'explanatory_notes_layer.dart';
import 'line_color_picker_button.dart';
import 'map_license_text.dart';
import 'map_scale_layer.dart';
import 'map_view_constants.dart';

final mapControllerProvider = Provider<MapController>(
  (ref) => MapController(),
);

class FlightAreaMapView extends ConsumerWidget {
  const FlightAreaMapView({
    super.key,
    this.outlineWidth,
    this.outlineColor = Colors.grey,
    this.fixedMapSize,
    this.onMapReady,
  });

  final double? outlineWidth;
  final Color outlineColor;
  final Size? fixedMapSize;
  final void Function()? onMapReady;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapController = ref.watch(mapControllerProvider);
    final tileInfo = ref.watch(currentTileInfoProvider);

    final lineColor = ref.watch(areaLineColorProvider);
    final polygons = ref
        .watch(polygonsProvider)
        .map(
          (e) => Polygon(
            points: e,
            isFilled: false,
            borderStrokeWidth: MapViewConstants.areaStrokeWidth,
            borderColor: lineColor,
          ),
        )
        .toList();

    final bounds = polygons.first.boundingBox;
    for (final poly in polygons.skip(1)) {
      bounds.extendBounds(poly.boundingBox);
    }
    final areaCenter = bounds.center;

    Widget decorate({required Widget child}) {
      Widget ret = child;

      if (fixedMapSize != null) {
        ret = SizedBox(
          width: fixedMapSize!.width,
          height: fixedMapSize!.height,
          child: ret,
        );
      }

      if (outlineWidth != null) {
        ret = DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: outlineColor,
              width: outlineWidth!,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
          child: ret,
        );
      }

      return ret;
    }

    return decorate(
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: polygons.isNotEmpty
              ? areaCenter
              : MapViewConstants.initialLocation,
          initialZoom: MapViewConstants.defaultZoomLevel,
          keepAlive: true,
          minZoom: MapViewConstants.minZoomLevel,
          maxZoom: MapViewConstants.maxZoomLevel,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all &
                ~InteractiveFlag.rotate &
                ~InteractiveFlag.pinchMove,
          ),
          onMapEvent: (MapEvent e) => MapScaleLayer.onMapEvent(ref, e),
          // onTap: (tapPosition, point) => logger.d('$tapPosition, $point'),
          onMapReady: onMapReady,
        ),
        nonRotatedChildren: const [
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: MapScaleLayer(width: MapViewConstants.mapScaleWidth),
            ),
          ),
          ExplanatoryNotesLayer(),
          MapLicenseText(),
        ],
        children: [
          TileLayer(
            urlTemplate: tileInfo.tileUri,
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'app.web.flight-area-exporter',
            maxZoom: 19,
          ),
          PolygonLayer(
            polygonLabels: false,
            polygons: polygons,
          ),
        ],
      ),
    );
  }
}
