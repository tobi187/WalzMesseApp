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
      notifyListeners();
      return;
    }

    var index = int.parse(callerIndex);
    var callerIndent = _items[index].indent;
    for (int i = index + 1; i < _items.length; i++) {
      if (callerIndent == _items[i].indent) {
        item.indent = callerIndent + 1;
        _items.insert(i, item.createCopy());
        break;
      }
    }

    notifyListeners();
  }

  void delItem(int index) {
    if (_items[index].type != CodeType.loop) {
      _items.removeAt(index);
      notifyListeners();
      return;
    }

    int end = _items.length;
    int currIndent = _items[index].indent;
    for (int i = index + 1; i < items.length; i++) {
      if (_items[i].indent < currIndent) {
        end = i;
        break;
      }
    }

    _items.removeRange(index, end);
    notifyListeners();
  }
}

enum CodeType { loop, turnLeft, turnRight, walk, adder }

class CodeItem {
  final String? text;
  int indent;
  final CodeType type;
  int _value = 0;

  void setValue(int val) => _value = val;
  int get value => _value;

  CodeItem({required this.type, this.text, this.indent = 0});

  CodeItem.adder(this.indent)
      : text = null,
        type = CodeType.adder;

  CodeItem createCopy() => CodeItem(type: type, text: text, indent: indent);
}
