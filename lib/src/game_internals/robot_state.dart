import 'dart:collection';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:game_template/src/game_internals/editor_state.dart';
import 'package:logging/logging.dart';

final class RobotState extends ChangeNotifier {
  final _logger = Logger("RobotState");

  final _rPosition = RobotPosition();

  bool _isAnimationPlaying = false;
  bool _isReady = false;
  final _animationDuration = Duration(seconds: 1);
  final List<String> borders;
  int cStep = 0;
  int cIndent = 0;
  bool hasError = false;
  VoidCallback onWin;
  VoidCallback onFail;

  RobotState(
      {required this.borders, required this.onWin, required this.onFail});
  List<CodeItem> steps = [];

  bool get isReady => _isReady;
  bool get isAnimationPlaying => _isAnimationPlaying;
  double get width => _rPosition.width;
  double get height => _rPosition.height;
  double get xStart => _rPosition.posX;
  double get yStart => _rPosition.posY;
  double get rotation => _rPosition.rotation;
  Duration get animationDuration => _animationDuration;

  Future<void> step(CodeType instruction) async {
    Duration dur = Duration(milliseconds: 300);
    switch (instruction) {
      case CodeType.turnRight:
        _rPosition.turnRight();
      case CodeType.turnLeft:
        _rPosition.turnLeft();
      case CodeType.walk:
        if (!canStep()) {
          hasError = true;
          return;
        }
        _rPosition.walk();
        dur = Duration(seconds: 1);
      default:
        throw Exception("Unexpected CodeType");
    }
    notifyListeners();
    cStep++;
    await Future<void>.delayed(dur);
  }

  List<CodeItem> skipLoopSteps() {
    List<CodeItem> l = [];
    for (int i = cStep; i < steps.length; i++) {
      if (steps[i].indent == steps[cStep].indent + 1 &&
          steps[i].type != CodeType.loop) {
        l.add(steps[i]);
      }
    }
    return l;
  }

  Future<void> startAnimation(List<CodeItem> items) async {
    _isAnimationPlaying = true;
    steps = items;

    while (cStep < steps.length) {
      if (hasError) return onFail();
      if (steps[cStep].type == CodeType.loop) {
        await doLoop();
      } else {
        await step(steps[cStep].type);
      }
    }
  }

  void cleanUp() {
    _isAnimationPlaying = false;
    cStep = 0;
    cIndent = 0;
    hasError = false;
    steps = [];
    _rPosition.resetPos();
    notifyListeners();
  }

  void fail() {
    cleanUp();
    onFail();
  }

  void win() {
    cleanUp();
    onWin();
  }

  Future<void> doLoop() async {
    final loopSteps = skipLoopSteps();
    int cIter = 0;
    int lStep = cStep;
    cStep++;

    if (steps[lStep].value == -1) {
      hasError = true;
      return;
    }

    while (steps[cIter].indent > steps[lStep].indent) {
      if (hasError) return;
      if (steps[cStep].type == CodeType.loop) {
        await doLoop();
      } else {
        await step(steps[cStep].type);
      }
      cStep++;
    }

    for (int i = 1; i < steps[lStep].value; i++) {
      for (var el in loopSteps) {
        await step(el.type);
      }
    }
  }

  bool canStep() {
    //r = 1, l = -1, dir 0 -> r, 90 -> b, 180 -> l, 270 -> t
    return switch (_rPosition.rotation) {
      0 => !borders[_rPosition.position].contains("r"),
      90 => !borders[_rPosition.position].contains("b"),
      180 => !borders[_rPosition.position].contains("l"),
      270 => !borders[_rPosition.position].contains("t"),
      _ => throw Exception("Unknown Rotation")
    };
  }

  void initPos(RenderObject? renderBox) {
    if (renderBox == null) throw Exception("Grid Column was null");
    final box = renderBox as RenderBox;

    final size = box.size;
    //final offset = box.localToGlobal(Offset.zero);
    _rPosition.initPos(null, null, size.height, size.width);
    _logger.info(_rPosition.toString());
    _isReady = true;
    notifyListeners();
  }
}

class Interpreter {
  final List<CodeItem> steps;
  final HashMap<CodeItem, List<CodeItem>> kids = HashMap();
  final HashMap<CodeItem, int> goBack = HashMap();
  final List<CodeItem> _base = List.empty(growable: true);

  Interpreter({required this.steps});

  void prepare() {
    CodeItem? curr;
    for (var step in steps) {
      if (step.indent != curr?.indent) {
        
      }
      if (step.indent == 0) {
        _base.add(step);
      } else {
        kids[curr]!.add(step);
      }

      if (step.type == CodeType.loop) {
        curr = step;
        kids[curr] = List.empty(growable: true);
      }
    }
  }
}

class RobotPosition {
  double posX = 0;
  double posY = 0;
  double height = 0;
  double width = 0;
  double rotation = 0;
  int position = 0;
  // spielfeld 5 rows 8 cols
  void initPos(double? x, double? y, double h, double w) {
    posX = x ?? 0;
    posY = y ?? 10;
    height = h;
    width = w;
  }

  void resetPos() {
    rotation = 0;
    posX = 0;
    posY = 10;
  }

  void turnLeft() {
    rotation -= 90;
    if (rotation < 0) {
      rotation += 360;
    }
  }

  void turnRight() {
    rotation += 90;
    if (rotation > 300) {
      rotation = 0;
    }
  }

  void walk() {
    switch (rotation) {
      case 0:
        posX += width;
        position++;
      case 90:
        posY += height;
        position += 8;
      case 180:
        posX -= width;
        position--;
      case 270:
        posY -= width;
        position -= 8;
      default:
        throw Exception("Rotation unknown");
    }
  }

  @override
  String toString() {
    return "x: $posX y: $posY height: $height width: $width";
  }
}
