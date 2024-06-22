import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'color_picker_dialog.dart';

class ToolsWidget extends StatelessWidget {
  final Function(Color) selectColor;
  final Function(double) selectStrokeWidth;
  final Function clearCanvas;

  ToolsWidget({required this.selectColor, required this.selectStrokeWidth, required this.clearCanvas});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.color_lens),
              onPressed: () async {
                Color? pickedColor = await showDialog(
                  context: context,
                  builder: (context) => ColorPickerDialog(Colors.black),
                );
                if (pickedColor != null) {
                  selectColor(pickedColor);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.brush),
              onPressed: () {
                selectStrokeWidth(5.0); // Example stroke width for brush
              },
            ),
            IconButton(
              icon: const Icon(Icons.create),
              onPressed: () {
                selectStrokeWidth(10.0);
              },
            ),
            IconButton(
              icon: Icon(MdiIcons.eraser),
              onPressed: () {
                selectStrokeWidth(20.0); // Example stroke width for eraser
              },
            ),
            IconButton(
              icon: Icon(MdiIcons.formatPaint),
              onPressed: () {
                // Implement bucket tool
                print('Bucket tool selected');
              },
            ),
            IconButton(
              icon: const Icon(Icons.layers),
              onPressed: () {
                // Implement layer tool
                print('Layer tool selected');
              },
            ),
          ],
        ),
      ),
    );
  }
}
