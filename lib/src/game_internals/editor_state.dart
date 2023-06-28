import 'package:flutter/material.dart';

class EditorState extends ChangeNotifier {
  final List<CodeItem> _items = List.empty(growable: true);
  bool _isAnimating = false;

  int get length => _items.length;
  List<CodeItem> get items => _items;
  bool get isAnimating => _isAnimating;

  List<CodeItem> startAnimation() {
    _isAnimating = true;
    notifyListeners();
    return _items;
  }

  void addItem(CodeItem item, String? callerIndex) {
    if (callerIndex == null) {
      _items.add(item.createCopy());
    } else {
      var index = int.parse(callerIndex);
      var callerItem = _items[index];
      bool inserted = false;
      for (int i = index + 1; i < _items.length; i++) {
        if (callerItem.indent == _items[i].indent) {
          item.indent = callerItem.indent + 1;
          _items.insert(i, item.createCopy());
          inserted = true;
          break;
        }
      }
      if (!inserted) {
        item.indent = callerItem.indent + 1;
        _items.add(item.createCopy());
      }
    }
    notifyListeners();
  }

  void delItem(int index) {
    if (_items[index].type == CodeType.loop) {
      int end = _items.length - 1;
      for (int i = index + 1; i < items.length; i++) {
        if (_items[i].indent != _items[index].indent) {
          end = i;
          break;
        }
      }
      _items.removeRange(index, ++end);
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }
}

enum CodeType { loop, turnLeft, turnRight, walk, adder }

class CodeItem {
  final String? text;
  int indent;
  final CodeType type;
  int? _value;

  void addValue(int val) => _value = val;

  CodeItem({required this.type, this.text, this.indent = 0});

  CodeItem.adder(this.indent)
      : text = null,
        type = CodeType.adder;

  CodeItem createCopy() => CodeItem(type: type, text: text, indent: indent);
}
