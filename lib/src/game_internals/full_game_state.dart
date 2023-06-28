import 'package:flutter/material.dart';
import 'package:game_template/src/game_internals/editor_state.dart';

class FullGameState extends ChangeNotifier {
  bool _isAnimating = false;
  List<CodeItem> _items = [];

  bool get isAnimating => _isAnimating;

  set isAnimating(bool val) {
    if (_isAnimating == val) return;
    _isAnimating = val;
    notifyListeners();
  }

  List<CodeItem> getItems() {
    var cp = List<CodeItem>.from(_items);
    _items.clear();
    return cp;
  }

  void setItems(List<CodeItem> items) {
    _items = items;
    notifyListeners();
  }
}
