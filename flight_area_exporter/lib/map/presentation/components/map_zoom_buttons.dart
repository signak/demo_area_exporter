import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'flight_area_map_view.dart';

class MapZoomButtons extends ConsumerWidget {
  final double minZoom;
  final double maxZoom;
  final bool mini;
  final double buttonPadding;
  final double gap;
  final Alignment alignment;
  final Color? zoomInColor;
  final Color? zoomInColorIcon;
  final Color? zoomOutColor;
  final Color? zoomOutColorIcon;
  final IconData zoomInIcon;
  final IconData zoomOutIcon;
  final EdgeInsets padding;

  const MapZoomButtons({
    super.key,
    this.minZoom = 1,
    this.maxZoom = 18,
    this.mini = true,
    this.buttonPadding = 2.0,
    this.gap = 2.0,
    this.alignment = Alignment.bottomCenter,
    this.zoomInColor,
    this.zoomInColorIcon,
    this.zoomInIcon = Icons.zoom_in,
    this.zoomOutColor,
    this.zoomOutColorIcon,
    this.zoomOutIcon = Icons.zoom_out,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(mapControllerProvider);
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: buttonPadding,
              top: buttonPadding,
              right: buttonPadding,
            ),
            child: FloatingActionButton(
              heroTag: 'zoomInButton',
              mini: mini,
              backgroundColor: zoomInColor ?? Theme.of(context).primaryColor,
              onPressed: () {
                var zoom = controller.camera.zoom + 0.25;
                if (zoom > maxZoom) {
                  zoom = maxZoom;
                }
                controller.move(controller.camera.center, zoom);
              },
              child: Icon(zoomInIcon,
                  color: zoomInColorIcon ?? IconTheme.of(context).color),
            ),
          ),
          Gap(gap),
          Padding(
            padding: EdgeInsets.only(
              left: buttonPadding,
              bottom: buttonPadding,
              right: buttonPadding,
            ),
            child: FloatingActionButton(
              heroTag: 'zoomOutButton',
              mini: mini,
              backgroundColor: zoomOutColor ?? Theme.of(context).primaryColor,
              onPressed: () {
                var zoom = controller.camera.zoom - 0.25;
                if (zoom < minZoom) {
                  zoom = minZoom;
                }
                controller.move(controller.camera.center, zoom);
              },
              child: Icon(zoomOutIcon,
                  color: zoomOutColorIcon ?? IconTheme.of(context).color),
            ),
          ),
        ],
        // ),
      ),
    );
  }
}
