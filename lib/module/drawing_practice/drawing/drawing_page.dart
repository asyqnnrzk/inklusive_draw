import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:InklusiveDraw/module/drawing_practice/drawing/widgets/'
    'drawing_canvas.dart';
import 'package:InklusiveDraw/module/drawing_practice/drawing/widgets/'
    'tools_widget.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../../../source/colors.dart';

class DrawingPage extends StatefulWidget {
  final List<CanvasDrawnLine>? initialLines;
  final Color? initialBackgroundColor;

  const DrawingPage({
    Key? key,
    this.initialLines,
    this.initialBackgroundColor,
  }) : super(key: key);

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

  @override
  void initState() {
    super.initState();

    if (widget.initialLines != null) {
      lines = widget.initialLines!;
    }
    if (widget.initialBackgroundColor != null) {
      backgroundColor = widget.initialBackgroundColor!;
    }
  }

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
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Save Drawing As',
            style: LightTextTheme.reportDetails,
          ),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Enter drawing name',
              hintStyle: LightTextTheme.reportDetails,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: LightTextTheme.cancelBtn,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Save',
                style: LightTextTheme.cancelBtn,
              ),
              onPressed: () {
                final name = nameController.text;
                if (name.isNotEmpty) {
                  final user = FirebaseAuth.instance.currentUser;
                  final userId = user?.uid ?? '';
                  saveDrawing(name, userId);
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
  Future<void> saveDrawing(String name, String userId) async {
    final directory = await getApplicationDocumentsDirectory();
    final now = DateTime.now();
    final formatter = DateFormat('yyyyMMdd_HHmmss');
    final fileName = '${userId}_drawing_${formatter.format(now)}';

    // Save JSON Data
    final file = File('${directory.path}/$fileName.json');
    final drawingData = {
      'userId': userId, // Store userId in the drawing data
      'name': name,
      'dateCreated': now.toIso8601String(),
      'lines': lines.map((line) => line.toJson()).toList(),
      'backgroundColor': backgroundColor.value,
    };
    await file.writeAsString(jsonEncode(drawingData));

    // Save Image File
    try {
      final boundary = key.currentContext?.findRenderObject() as
      RenderRepaintBoundary?;
      final image = await boundary?.toImage();
      final byteData = await image?.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();
      final imageFile = File('${directory.path}/$fileName.png');
      await imageFile.writeAsBytes(pngBytes!);
    } catch (e) {
      print('Error saving image: $e');
    }
  }

  Future<List<File>> listSavedDrawings(String userId) async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync().whereType<File>().toList();
    // Filter files by userId in the file name
    return files.where((file) =>
    file.path.endsWith('.json') && file.path.contains('${userId}_')).toList();
  }

  Future<void> loadDrawing(String userId, String drawingFileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$drawingFileName.json');
    if (await file.exists()) {
      final drawingData = jsonDecode(await file.readAsString());
      if (drawingData['userId'] == userId) {
        final List<CanvasDrawnLine> loadedLines = (drawingData['lines'] as List)
            .map((lineJson) => CanvasDrawnLine.fromJson(lineJson))
            .toList();
        setState(() {
          lines = loadedLines;
          backgroundColor = Color(drawingData['backgroundColor']);
        });
      }
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

    Get.snackbar(
      '',
      '',
      titleText: Text(
        'Saving...',
        style: LightTextTheme.snackbarTxt,
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: greenButton,
      colorText: blackColor,
    );
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
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'Have you save this?',
                    style: LightTextTheme.reportDetails,
                  ),
                  content: Text(
                    'Make sure to save first!',
                    style: LightTextTheme.reportDetails,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: LightTextTheme.cancelBtn,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Yes',
                        style: LightTextTheme.deleteBtn,
                      ),
                    ),
                  ],
                );
              },
            );
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

