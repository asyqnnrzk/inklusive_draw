import 'dart:ui';
import 'package:flutter/material.dart';

class DrawnLine {
  List<Offset> path;
  Paint paint;

  DrawnLine({required this.path, required this.paint});
}

class DrawingCanvas extends StatefulWidget {
  final List<DrawnLine> lines;
  final Color selectedColor;
  final double brushThickness;
  final String selectedTool;
  final Function(DrawnLine) addLine;
  final Function(Offset) eraseAt;

  DrawingCanvas({
    required this.lines,
    required this.selectedColor,
    required this.brushThickness,
    required this.selectedTool,
    required this.addLine,
    required this.eraseAt,
  });

  @override
  _DrawingCanvasState createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<Offset> currentPath = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        RenderBox renderBox = context.findRenderObject() as RenderBox;
        Offset localPosition = renderBox.globalToLocal(details.globalPosition);

        if (widget.selectedTool == 'eraser') {
          widget.eraseAt(localPosition);
        } else {
          setState(() {
            currentPath.add(localPosition);
          });
        }
      },
      onPanEnd: (details) {
        if (widget.selectedTool != 'eraser' && currentPath.isNotEmpty) {
          Paint paint = Paint()
            ..color = widget.selectedColor
            ..strokeCap = StrokeCap.round
            ..strokeWidth = widget.selectedTool == 'brush'
                ? widget.brushThickness
                : 2.0;
          DrawnLine line = DrawnLine(path: List.from(currentPath), paint: paint);
          widget.addLine(line);
          setState(() {
            currentPath.clear();
          });
        }
      },
      child: CustomPaint(
        painter: _DrawingPainter(
          lines: widget.lines,
          currentPath: currentPath,
          selectedTool: widget.selectedTool,
          currentColor: widget.selectedColor,
          brushThickness: widget.brushThickness,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawnLine> lines;
  final List<Offset> currentPath;
  final String selectedTool;
  final Color currentColor;
  final double brushThickness;

  _DrawingPainter({
    required this.lines,
    required this.currentPath,
    required this.selectedTool,
    required this.currentColor,
    required this.brushThickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var line in lines) {
      canvas.drawPoints(PointMode.polygon, line.path, line.paint);
    }
    if (selectedTool != 'eraser') {
      Paint paint = Paint()
        ..color = currentColor
        ..strokeCap = StrokeCap.round
        ..strokeWidth = brushThickness;
      canvas.drawPoints(PointMode.polygon, currentPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
