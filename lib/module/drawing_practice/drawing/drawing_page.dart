import 'package:InklusiveDraw/module/drawing_practice/drawing/widgets/drawing_canvas.dart';
import 'package:InklusiveDraw/module/drawing_practice/drawing/widgets/tools_widget.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../source/colors.dart';

class DrawingPage extends StatefulWidget {
  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  List<Offset?> points = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 5.0;

  void selectColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  void selectStrokeWidth(double width) {
    setState(() {
      strokeWidth = width;
    });
  }

  void clearCanvas() {
    setState(() {
      points.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
      ),
      body: DrawingCanvas(points, selectedColor, strokeWidth),
      bottomNavigationBar: BottomAppBar(
        color: primaryColor,
        child: ToolsWidget(
          selectColor: selectColor,
          selectStrokeWidth: selectStrokeWidth,
          clearCanvas: clearCanvas,
        ),
      ),
    );
  }
}
