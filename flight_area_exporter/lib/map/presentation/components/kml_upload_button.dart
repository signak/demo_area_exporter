import 'dart:async';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/utils/kml_reader.dart';
import '../../../core/utils/logger.dart';
import '../controllers/home_screen_controller.dart';
import 'flight_area_map_view.dart';
import 'map_view_constants.dart';

class KmlUploadButton extends ConsumerWidget {
  const KmlUploadButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapController = ref.watch(mapControllerProvider);

    return ElevatedButton.icon(
      onPressed: () async {
        const XTypeGroup typeGroup = XTypeGroup(
          label: 'kml',
          extensions: <String>['kml', 'xml'],
        );
        final XFile? file =
            await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
        if (file == null) {
          return;
        }

        final data = await KmlReader.loadKML(await file.readAsString());

        final bounds = LatLngBounds.fromPoints(data.values.first);
        for (final points in data.values.skip(1)) {
          bounds.extendBounds(
            LatLngBounds.fromPoints(points),
          );
        }

        final areaCenter = bounds.center;
        mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.all(48),
            maxZoom: MapViewConstants.maxAutoZoomLevel,
            minZoom: MapViewConstants.minZoomLevel,
          ),
        );

        final mapMoveCompleter = Completer<bool>();
        const distance = Distance();

        const int timeoutLimitMsec = 3000;
        const int intervalMsec = 100;
        const int maxTick = timeoutLimitMsec ~/ intervalMsec;
        const int acceptableMaxDistanceMeter = 10;

        Timer.periodic(const Duration(milliseconds: 100), (timer) {
          final screenCenter = mapController.camera.center;
          final m = distance.as(LengthUnit.Meter, areaCenter, screenCenter);
          if (m <= acceptableMaxDistanceMeter) {
            mapMoveCompleter.complete(true);
            logger.i(
              'Moved camera to new flight area. '
              '(${(timer.tick - 1) * intervalMsec} msec.)',
            );
            timer.cancel();
          } else if (timer.tick >= maxTick) {
            // timeout
            mapMoveCompleter.complete(false);
            timer.cancel();
          }
        });

        await mapMoveCompleter.future.then((isSucceed) {
          if (!isSucceed) {
            logger.w('Failed to move camera to new flight area.');
          }
          ref
              .read(polygonsProvider.notifier)
              .update((state) => data.values.toList());
        });
      },
      icon: const Icon(Icons.upload),
      label: const Text('Load KML'),
    );
  }
}
