import 'package:flutter/material.dart';

class EditorState extends ChangeNotifier {
  final List<CodeItem> _items = [];

  int get length => _items.length * 2 + 1;
  List<CodeItem> get items => _items;

  void addItem(CodeItem item, int callerIndex) {
    
    notifyListeners();
  }
}

enum CodeType { loop, turnLeft, turnRight, walk, adder }

class CodeItem {
  final String? text;
  final int indent;
  final CodeType type;
  int _childCount = 0;

  int get childCount => _childCount;
  void addChild() => _childCount++;
  void removeChild() => _childCount--;

  CodeItem({required this.type, this.text, this.indent = 0});

  CodeItem.adder(this.indent)
      : text = null,
        type = CodeType.adder;
}
