import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
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
            // current color
            IconButton(
              icon: const Icon(Icons.color_lens),
              onPressed: () async {
                Color pickedColor = await showDialog(
                  context: context,
                  builder: (context) => ColorPickerDialog(Colors.black),
                );
                if (pickedColor != null) {
                  selectColor(pickedColor);
                }
              },
            ),
            // brush type
            IconButton(
              icon: const Icon(Icons.brush),
              onPressed: () {

              },
            ),
            // brush mode
            IconButton(
              icon: const Icon(Icons.create),
              onPressed: () {
                selectStrokeWidth(10.0);
              },
            ),
            // eraser mode
            IconButton(
              icon: Icon(MdiIcons.eraser),
              onPressed: () {

              },
            ),
            // bucket mode
            IconButton(
              icon: Icon(MdiIcons.formatPaint),
              onPressed: () {

              },
            ),
            // layer
            IconButton(
              icon: const Icon(Icons.layers),
              onPressed: () {

              },
            ),
            // more tools
            IconButton(
              icon: Icon(MdiIcons.more),
              onPressed: () {

              },
            ),
          ],
        ),
      ),
    );
  }
}
