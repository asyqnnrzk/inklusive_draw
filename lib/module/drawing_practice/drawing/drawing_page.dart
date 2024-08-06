import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:InklusiveDraw/module/drawing_practice/drawing/widgets/drawing_canvas.dart';
import 'package:InklusiveDraw/module/drawing_practice/drawing/widgets/tools_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/rendering.dart';

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
  Color backgroundColor = Colors.white;
  File? _image;

  List<Color> backgroundColorHistory = [Colors.white];
  List<Color> undoBackgroundColorHistory = [];

  final ImagePicker _picker = ImagePicker();
  final GlobalKey key = GlobalKey();

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
      _image = null;
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

  Future<void> importDrawing() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> exportDrawing() async {
    try {
      final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      final image = await boundary?.toImage();
      final byteData = await image?.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      final result = await ImageGallerySaver.saveImage(Uint8List.fromList(pngBytes!));
      print(result);
    } catch (e) {
      print(e);
    }
  }

  void undo() {
    setState(() {
      if (lines.isNotEmpty) {
        undoLines.add(lines.removeLast());
      } else if (backgroundColorHistory.length > 1) {
        undoBackgroundColorHistory.add(backgroundColorHistory.removeLast());
        backgroundColor = backgroundColorHistory.last;
      }
    });
  }

  void redo() {
    setState(() {
      if (undoLines.isNotEmpty) {
        lines.add(undoLines.removeLast());
      } else if (undoBackgroundColorHistory.isNotEmpty) {
        backgroundColorHistory.add(undoBackgroundColorHistory.removeLast());
        backgroundColor = backgroundColorHistory.last;
      }
    });
  }

  void changeBackgroundColor(Color color) {
    setState(() {
      backgroundColor = color;
      backgroundColorHistory.add(color);
      undoBackgroundColorHistory.clear();
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
            icon: const Icon(Icons.file_upload),
            onPressed: importDrawing,
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: exportDrawing,
          ),
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
      body: RepaintBoundary(
        key: key,
        child: Stack(
          children: [
            if (_image != null)
              Image.file(
                _image!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            DrawingCanvas(
              lines: lines,
              selectedColor: selectedColor,
              brushThickness: brushThickness,
              selectedTool: selectedTool,
              addLine: addLine,
              eraseAt: eraseAt,
              backgroundColor: backgroundColor,
              changeBackgroundColor: changeBackgroundColor,
            ),
          ],
        ),
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
