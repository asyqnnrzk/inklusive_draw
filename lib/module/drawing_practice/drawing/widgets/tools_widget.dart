import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter'
    '.dart';
import 'color_picker_dialog.dart';

class ToolsWidget extends StatelessWidget {
  final Function(Color) selectColor;
  final Function(double) selectBrushThickness;
  final Function(String) selectTool;
  final Function clearCanvas;
  final String selectedTool;
  final double brushThickness;

  ToolsWidget({
    required this.selectColor,
    required this.selectBrushThickness,
    required this.selectTool,
    required this.clearCanvas,
    required this.selectedTool,
    required this.brushThickness,
  });

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
                Color pickedColor = await showDialog(
                  context: context,
                  builder: (context) => ColorPickerDialog(Colors.black),
                );
                selectColor(pickedColor);
              },
            ),
            IconButton(
              icon: const Icon(Icons.brush),
              onPressed: () {
                selectTool('brush');
              },
              color: selectedTool == 'brush' ? Colors.blue : Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.create),
              onPressed: () {
                selectTool('pencil');
              },
              color: selectedTool == 'pencil' ? Colors.blue : Colors.black,
            ),
            IconButton(
              icon: Icon(MdiIcons.eraser),
              onPressed: () {
                selectTool('eraser');
              },
              color: selectedTool == 'eraser' ? Colors.blue : Colors.black,
            ),
            IconButton(
              icon: const Icon(LineAwesomeIcons.trash_alt),
              onPressed: () {
                clearCanvas();
              },
            ),
            if (selectedTool == 'brush') ...[
              Slider(
                value: brushThickness,
                min: 1.0,
                max: 20.0,
                onChanged: (value) {
                  selectBrushThickness(value);
                },
              ),
            ]
          ],
        ),
      ),
    );
  }
}
