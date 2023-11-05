import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'line_color_picker_button.g.dart';

@Riverpod(keepAlive: true)
class AreaLineColor extends _$AreaLineColor {
  @override
  Color build() => const Color.fromRGBO(245, 0, 87, 1);

  void update(Color newColor) => state = newColor;
}

class LineColorPickerButton extends ConsumerWidget {
  const LineColorPickerButton({super.key});

  static const int _portraitCrossAxisCount = 4;
  static const int _landscapeCrossAxisCount = 5;
  static const double _borderRadius = 30;
  static const double _blurRadius = 5;
  static const double _iconSize = 24;

  static const List<Color> _colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
  ];

  Widget pickerLayoutBuilder(
      BuildContext context, List<Color> colors, PickerItem child) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return SizedBox(
      width: 300,
      height: orientation == Orientation.portrait ? 360 : 240,
      child: GridView.count(
        crossAxisCount: orientation == Orientation.portrait
            ? _portraitCrossAxisCount
            : _landscapeCrossAxisCount,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        children: [for (final color in colors) child(color)],
      ),
    );
  }

  Widget pickerItemBuilder(
      Color color, bool isCurrentColor, void Function() changeColor) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: color,
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.8),
              offset: const Offset(1, 2),
              blurRadius: _blurRadius)
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: changeColor,
          borderRadius: BorderRadius.circular(_borderRadius),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: isCurrentColor ? 1 : 0,
            child: Icon(
              Icons.done,
              size: _iconSize,
              color: useWhiteForeground(color) ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lineColor = ref.watch(areaLineColorProvider);

    void pickColor(BuildContext ownerContext) {
      showDialog(
        context: ownerContext,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Select a color'),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: lineColor,
                onColorChanged: (newColor) {
                  ref.read(areaLineColorProvider.notifier).update(newColor);
                },
                availableColors: _colors,
                layoutBuilder: pickerLayoutBuilder,
                itemBuilder: pickerItemBuilder,
              ),
            ),
          );
        },
      );
    }

    return ElevatedButton.icon(
      onPressed: () {
        pickColor(context);
      },
      icon: Icon(
        Icons.settings,
        color: ref.watch(areaLineColorProvider),
      ),
      label: Text(
        '線色: #${lineColor.value.toRadixString(16).substring(2)}',
        style: TextStyle(color: lineColor),
      ),
    );
  }
}
