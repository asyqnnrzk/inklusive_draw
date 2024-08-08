import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:InklusiveDraw/module/drawing_practice/drawing/widgets/'
    'drawing_canvas.dart';
import 'package:InklusiveDraw/module/drawing_practice/drawing/widgets/'
    'tools_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class DrawingPage extends StatefulWidget {
  final List<CanvasDrawnLine>? initialLines;
  final Color? initialBackgroundColor;

  DrawingPage({
    this.initialLines,
    this.initialBackgroundColor,
  });

  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  List<CanvasDrawnLine> lines = [];
  List<CanvasDrawnLine> undoLines = [];
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

  void addLine(CanvasDrawnLine line) {
    setState(() {
      lines.add(line);
    });
  }

  void eraseAt(Offset point) {
    setState(() {
      for (var line in lines) {
        line.path.removeWhere((linePoint) => (linePoint - point).distance <=
            brushThickness);
      }
      lines.removeWhere((line) => line.path.isEmpty);
    });
  }

  Future<void> promptSaveAsDialog() async {
    final TextEditingController nameController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Drawing As'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Enter drawing name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                final name = nameController.text;
                if (name.isNotEmpty) {
                  saveDrawing(name);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Function to save the drawing
  Future<void> saveDrawing(String name) async {
    final directory = await getApplicationDocumentsDirectory();
    final now = DateTime.now();
    final formatter = DateFormat('yyyyMMdd_HHmmss');
    final fileName = 'drawing_${formatter.format(now)}';

    // Save JSON Data
    final file = File('${directory.path}/$fileName.json');
    final drawingData = {
      'name': name,
      'dateCreated': now.toIso8601String(),
      'lines': lines.map((line) => line.toJson()).toList(),
      'backgroundColor': backgroundColor.value,
    };
    await file.writeAsString(jsonEncode(drawingData));

    // Save Image File
    try {
      final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      final image = await boundary?.toImage();
      final byteData = await image?.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();
      final imageFile = File('${directory.path}/$fileName.png');
      await imageFile.writeAsBytes(pngBytes!);
    } catch (e) {
      print('Error saving image: $e');
    }
  }

  Future<List<File>> listSavedDrawings() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync().whereType<File>().toList();
    return files.where((file) => file.path.endsWith('.json')).toList();
  }

  Future<void> loadDrawing() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/drawing.json');
    if (await file.exists()) {
      final drawingData = jsonDecode(await file.readAsString());
      final List<CanvasDrawnLine> loadedLines = (drawingData['lines'] as List)
          .map((lineJson) => CanvasDrawnLine.fromJson(lineJson))
          .toList();
      setState(() {
        lines = loadedLines;
        backgroundColor = Color(drawingData['backgroundColor']);
      });
    }
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
      final boundary = key.currentContext?.findRenderObject() as
      RenderRepaintBoundary?;
      final image = await boundary?.toImage();
      final byteData = await image?.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      final result = await ImageGallerySaver.saveImage(Uint8List.fromList
        (pngBytes!));
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
            icon: const Icon(Icons.save),
            onPressed: promptSaveAsDialog,
          ),
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

