import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'line_color_picker_button.dart';

class ExplanatoryNotesLayer extends ConsumerWidget {
  const ExplanatoryNotesLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lineColor = ref.watch(areaLineColorProvider);

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
        left: 24,
      ),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 44,
                  decoration: BoxDecoration(
                    border: Border.all(color: lineColor, width: 4),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 8, 8),
                  child: Text("業務対象範囲",
                      style: TextStyle(
                        color: lineColor,
                        fontSize: 24,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
