// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';

/// An extremely silly example of a game state.
///
/// Tracks only a single variable, [progress], and calls [onWin] when
/// the value of [progress] reaches [goal].
class FortuneWheelState extends ChangeNotifier {
  final VoidCallback onWin;
  
  FortuneWheelState({required this.onWin});

  bool _isOver = false;
  String? _itemWon;

  bool get isOver => _isOver;
  bool get hasWon => _itemWon?.isNotEmpty ?? false;

  void spinFinished(String? item) {
    _isOver = true;
    _itemWon = item;
    if (hasWon) {
      onWin();
    }
  }
}
