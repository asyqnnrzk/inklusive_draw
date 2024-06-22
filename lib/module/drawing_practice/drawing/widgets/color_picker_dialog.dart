import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color initialColor;

  ColorPickerDialog(this.initialColor);

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color pickedColor;

  @override
  void initState() {
    super.initState();
    pickedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pick a color'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: pickedColor,
          onColorChanged: (color) {
            setState(() {
              pickedColor = color;
            });
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Select'),
          onPressed: () {
            Navigator.of(context).pop(pickedColor);
          },
        ),
      ],
    );
  }
}
