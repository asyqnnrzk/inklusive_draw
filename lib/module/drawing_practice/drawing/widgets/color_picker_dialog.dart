import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color currentColor;

  ColorPickerDialog(this.currentColor);

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color selectedColor;

  _ColorPickerDialogState() : selectedColor = Colors.black;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.currentColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick a color'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: selectedColor,
          onColorChanged: (color) {
            setState(() {
              selectedColor = color;
            });
          },
          pickerAreaHeightPercent: 0.8,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Select'),
          onPressed: () {
            Navigator.of(context).pop(selectedColor);
          },
        ),
      ],
    );
  }
}
