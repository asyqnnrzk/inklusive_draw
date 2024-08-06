import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackgroundColorController extends GetxController {
  var backgroundColor = Colors.white.obs;
  List<Color> backgroundColorHistory = [Colors.white];
  List<Color> undoBackgroundColorHistory = [];

  void changeBackgroundColor(Color color) {
    backgroundColor.value = color;
    backgroundColorHistory.add(color);
    undoBackgroundColorHistory.clear();
  }

  void undo() {
    if (backgroundColorHistory.length > 1) {
      undoBackgroundColorHistory.add(backgroundColorHistory.removeLast());
      backgroundColor.value = backgroundColorHistory.last;
    }
  }

  void redo() {
    if (undoBackgroundColorHistory.isNotEmpty) {
      backgroundColorHistory.add(undoBackgroundColorHistory.removeLast());
      backgroundColor.value = backgroundColorHistory.last;
    }
  }
}
