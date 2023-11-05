import 'package:flight_area_exporter/map/presentation/components/kml_upload_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:screenshot/screenshot.dart';

import '../components/flight_area_map_view.dart';
import '../components/line_color_picker_button.dart';
import '../components/map_view_constants.dart';
import '../components/map_zoom_buttons.dart';
import '../components/screenshot_button.dart';
import '../components/tile_select_dropdown.dart';

class MyHomeScreen extends ConsumerWidget {
  const MyHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenshotController = ref.watch(screenshotControllerProvider);

    const zoomButtonColor = Color.fromRGBO(255, 209, 128, 1);

    return Scaffold(
      appBar: AppBar(title: const Text("飛行エリア出力")),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: MapViewConstants.mapWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TileSelectDropDown(),
                      LineColorPickerButton(),
                      KmlUploadButton(),
                      ScreenshotButton(),
                    ],
                  ),
                ),
                const Gap(12),
                Screenshot(
                  controller: screenshotController,
                  child: const FlightAreaMapView(
                    outlineColor: Colors.grey,
                    outlineWidth: 1,
                    fixedMapSize: Size(
                      MapViewConstants.mapWidth,
                      MapViewConstants.mapHeight,
                    ),
                    onMapReady: FlutterNativeSplash.remove,
                  ),
                ),
              ],
            ),
            const MapZoomButtons(
              padding: EdgeInsets.only(left: 12, bottom: 8),
              maxZoom: MapViewConstants.maxZoomLevel,
              minZoom: MapViewConstants.minZoomLevel,
              gap: 12,
              zoomInColor: zoomButtonColor,
              zoomOutColor: zoomButtonColor,
            ),
          ],
        ),
      ),
    );
  }
}
