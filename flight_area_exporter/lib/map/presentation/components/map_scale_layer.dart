import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import 'flight_area_map_view.dart';

@immutable
class ScaleUnit {
  const ScaleUnit({
    required this.zoom,
    required this.meter,
    required this.pixel,
    required this.unitValue,
    required this.unitText,
  });

  factory ScaleUnit.unknown() {
    return const ScaleUnit(
        zoom: -1, meter: -1, unitValue: -1, unitText: 'unknown', pixel: -1);
  }

  /// map zoom value.
  final double zoom;

  /// 1 unit meters.
  final int meter;

  /// width of 1 unit bar pixels.
  final int pixel;

  /// 1 unit value. meter or kilo meter.
  final double unitValue;

  /// unit text. m or km.
  final String unitText;
}

final _scaleUnitProvider = StateProvider<ScaleUnit?>((ref) => null);

class MapScaleLayer extends ConsumerWidget {
  const MapScaleLayer({super.key, required this.width});

  static const int scaleBarCount = 4;
  static const dist = Distance();
  final int width;

  static void onMapEvent(WidgetRef ref, MapEvent event) {
    final scaleUnit = ref.read(_scaleUnitProvider);
    if (event.runtimeType == MapEventDoubleTapZoomEnd ||
        event.runtimeType == MapEventMove ||
        event.runtimeType == MapEventScrollWheelZoom) {
      final newZoom = event.camera.zoom;
      if (scaleUnit == null || scaleUnit.zoom != newZoom) {
        final map = ref.read(mapControllerProvider);
        final newScaleUnit = _getScaleUnit(map);
        ref.read(_scaleUnitProvider.notifier).update((state) => newScaleUnit);
        // logger.d(
        //     'onMapEvent ${event.runtimeType}: ${scaleUnit?.zoom} to $newZoom');
      } else {
        // logger.d('onMapEvent ${event.runtimeType}: no zoom changed');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScaleUnit su = ref.watch(_scaleUnitProvider) ??
        _getScaleUnit(ref.watch(mapControllerProvider));

    return Container(
      padding: const EdgeInsets.all(4),
      color: Colors.white.withOpacity(0.7),
      child: CustomPaint(
        size: Size(su.pixel * 4 + 48, 40),
        painter: LinePainter(scaleUnit: su, count: 4, strokeWidth: 10),
      ),
    );
  }

  static ScaleUnit _getScaleUnit(MapController map) {
    const double widthPixel = 100;
    final topLeft = map.camera.pointToLatLng(const Point(0, 0));
    final topRight = map.camera.pointToLatLng(const Point(widthPixel, 0));

    // logger.d('[ScaleUnit] topLeft: $topLeft, topRight: $topRight');

    final widthMeter = dist.as(LengthUnit.Meter, topLeft, topRight);

    // logger.d('[ScaleUnit] widthPixel: $widthPixel, widthMeter: $widthMeter');

    return _buildScaleUnit(map.camera.zoom, widthPixel, widthMeter);
  }

  static const int maxSafeJSInteger = 0x20000000000000;
  static const scaleRanges = <int>[
    0,
    10,
    25,
    50,
    100,
    150,
    250,
    500,
    1000,
    2000,
    4000,
    8000,
    15000,
    25000,
    50000,
    100000,
    maxSafeJSInteger,
  ];

  static int _getScaleRange(double unitMeter) {
    final int lastIndex = scaleRanges.length - 1;

    for (int i = 1; i <= lastIndex - 1; i++) {
      final minScale = scaleRanges[i - 1];
      final targetScale = scaleRanges[i];
      final maxScale = targetScale + ((scaleRanges[i + 1] - targetScale) / 2);
      if (minScale <= unitMeter && unitMeter < maxScale) {
        return targetScale;
      }
    }

    return 0;
  }

  static ScaleUnit _buildScaleUnit(
      double zoom, double unitPixel, double unitMeter) {
    final int meter = _getScaleRange(unitMeter);
    if (meter == 0) {
      return ScaleUnit.unknown();
    }

    late final String unitText;
    late final double unitValue;
    if (meter >= 1000) {
      unitText = 'km';
      unitValue = (meter / 1000);
    } else if (meter * scaleBarCount >= 1000) {
      unitText = 'km';
      unitValue = (meter / 1000);
    } else {
      unitText = 'm';
      unitValue = meter.toDouble();
    }

    final mag = meter / unitMeter;
    final pixel = (unitPixel * mag).round();

    // logger.d(
    //     '[ScaleUnit] meter: $meter, unitMeter: ${unitMeter.round()}, mag: $mag');

    // logger.d(
    //     '[ScaleUnit] pixel: $pixel, unitPixel: ${(unitPixel).round()}, mag: $mag');

    return ScaleUnit(
      zoom: zoom,
      meter: meter,
      unitValue: unitValue,
      unitText: unitText,
      pixel: pixel,
    );
  }
}

class LinePainter extends CustomPainter {
  const LinePainter({
    required this.scaleUnit,
    required this.count,
    required this.strokeWidth,
    this.textColor = Colors.black,
    this.oddColor = Colors.black,
    this.evenColor = Colors.white,
  });

  final ScaleUnit scaleUnit;
  final int count;
  final double strokeWidth;
  final Color textColor;
  final Color evenColor;
  final Color oddColor;

  @override
  void paint(Canvas canvas, Size size) {
    final oddPaint = Paint()
      ..color = oddColor
      ..strokeWidth = strokeWidth;

    final evenPaint = Paint()
      ..color = evenColor
      ..strokeWidth = strokeWidth;

    final width = scaleUnit.pixel;
    final height = size.height / 2;

    late final Offset barStartPos;
    late final double leftPad;

    for (int i = -1; i < count; i++) {
      final text = ((i + 1) * scaleUnit.unitValue)
          .toString()
          .padLeft('${scaleUnit.unitValue}'.length);
      final unitText = (i == count - 1) ? scaleUnit.unitText : '';
      final textSpan = TextSpan(
        style: TextStyle(color: textColor, fontSize: 16),
        text: '$text$unitText',
      );
      final textPainter =
          TextPainter(text: textSpan, textDirection: TextDirection.ltr)
            ..layout();

      if (i == 0) {
        leftPad = textPainter.size.width / 2;
      }

      late final double tx;
      if (i == count - 1) {
        tx = width * (i + 1) - leftPad;
      } else {
        tx = width * (i + 1);
      }
      textPainter.paint(canvas, Offset(tx, 4));

      if (i == -1) {
        continue;
      }

      final start = Offset(leftPad + (i * width), (height / 2) + height);
      final end = Offset(leftPad + ((i + 1) * width), (height / 2) + height);
      final paint = (i + 1).isOdd ? oddPaint : evenPaint;
      canvas.drawLine(start, end, paint);

      if (i == 0) {
        barStartPos = start;
      }
    }

    final rect = Rect.fromLTWH(
        barStartPos.dx,
        barStartPos.dy - (strokeWidth / 2),
        (scaleUnit.pixel * count).toDouble(),
        strokeWidth);
    final rectPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = oddColor
      ..strokeWidth = 1;
    canvas.drawRect(rect, rectPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
