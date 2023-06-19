import 'package:flutter/material.dart';

class EditorState extends ChangeNotifier {
  final List<CodeItem> _items = List.empty(growable: true);

  int get length => _items.length;
  List<CodeItem> get items => _items;

  void addItem(CodeItem item, String? callerIndex) {
    if (callerIndex == null) {
      _items.add(item);
    } else {
      int index = int.parse(callerIndex);
      _items.insert(_items[index].childCount + index + 1, item);
    }
    notifyListeners();
  }
}

enum CodeType { loop, turnLeft, turnRight, walk, adder }

class CodeItem {
  final String? text;
  final int indent;
  final CodeType type;
  int _childCount = 0;
  int? _value;

  int get childCount => _childCount;
  void addChild() => _childCount++;
  void removeChild() => _childCount--;
  void addValue(int val) => _value = val;

  CodeItem({required this.type, this.text, this.indent = 0});

  CodeItem.adder(this.indent)
      : text = null,
        type = CodeType.adder;
}
