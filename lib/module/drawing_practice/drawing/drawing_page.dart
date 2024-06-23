import 'package:InklusiveDraw/module/drawing_practice/drawing/widgets/drawing_canvas.dart';
import 'package:InklusiveDraw/module/drawing_practice/drawing/widgets/tools_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../source/colors.dart';

class DrawingPage extends StatefulWidget {
  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  List<DrawnLine> lines = [];
  List<DrawnLine> undoLines = [];
  Color selectedColor = Colors.black;
  double brushThickness = 5.0;
  String selectedTool = 'brush';

  void selectColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  void selectBrushThickness(double thickness) {
    setState(() {
      brushThickness = thickness;
    });
  }

  void selectTool(String tool) {
    setState(() {
      selectedTool = tool;
    });
  }

  void clearCanvas() {
    setState(() {
      lines.clear();
      undoLines.clear();
    });
  }

  void addLine(DrawnLine line) {
    setState(() {
      lines.add(line);
    });
  }

  void eraseAt(Offset point) {
    setState(() {
      for (var line in lines) {
        line.path.removeWhere((linePoint) => (linePoint - point).distance <= brushThickness);
      }
      lines.removeWhere((line) => line.path.isEmpty);
    });
  }

  void undo() {
    setState(() {
      if (lines.isNotEmpty) {
        undoLines.add(lines.removeLast());
      }
    });
  }

  void redo() {
    setState(() {
      if (undoLines.isNotEmpty) {
        lines.add(undoLines.removeLast());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: undo,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: redo,
          ),
        ],
      ),
      body: DrawingCanvas(
        lines: lines,
        selectedColor: selectedColor,
        brushThickness: brushThickness,
        selectedTool: selectedTool,
        addLine: addLine,
        eraseAt: eraseAt,
      ),
      bottomNavigationBar: BottomAppBar(
        color: backgroundColor,
        child: ToolsWidget(
          selectColor: selectColor,
          selectBrushThickness: selectBrushThickness,
          selectTool: selectTool,
          clearCanvas: clearCanvas,
          selectedTool: selectedTool,
          brushThickness: brushThickness,
        ),
      ),
    );
  }
}
