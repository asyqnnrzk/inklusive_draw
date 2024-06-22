import 'dart:ui';
import 'package:flutter/material.dart';

class DrawingCanvas extends StatefulWidget {
  final List<Offset?> points;
  final Color selectedColor;
  final double strokeWidth;

  DrawingCanvas(this.points, this.selectedColor, this.strokeWidth);

  @override
  _DrawingCanvasState createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          widget.points.add(details.localPosition);
        });
      },
      onPanEnd: (details) {
        widget.points.add(null); // To separate strokes
      },
      child: CustomPaint(
        painter: CanvasPainter(widget.points, widget.selectedColor, widget.strokeWidth),
        child: Container(
          color: Colors.white,
        ),
      ),
    );
  }
}

class CanvasPainter extends CustomPainter {
  final List<Offset?> points;
  final Color color;
  final double strokeWidth;

  CanvasPainter(this.points, this.color, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [points[i]!], paint);
      }
    }
  }

  @override
  bool shouldRepaint(CanvasPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
