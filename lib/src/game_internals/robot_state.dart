import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final class RobotState extends ChangeNotifier {
  static double borderWidth = 2;
  static double stAlign = -1;

  final _logger = Logger("RobotState");

  final _rPosition = RobotPosition();

  bool _isAnimationPlaying = false;
  bool _isReady = false;
  int currentStep = 0;

  final steps = ["right", "right", "down", "right"];

  bool get isReady => _isReady;
  bool get isAnimationPlaying => _isAnimationPlaying;
  double get width => _rPosition.width;
  double get height => _rPosition.height;
  double get xStart => _rPosition.posX;
  double get yStart => _rPosition.posY;

  void step() {
    if (currentStep >= steps.length) {
      _isAnimationPlaying = false;
      return;
    }
    switch (steps[currentStep]) {
      case "right":
        _rPosition.walkRight();
      case "left":
        _rPosition.walkLeft();
      case "up":
        _rPosition.walkTop();
      case "down":
        _rPosition.walkBot();
    }
    currentStep++;
    notifyListeners();
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
    Future.delayed(Duration(seconds: 3), step);
  }
}

class RobotPosition {
  double posX = 0;
  double posY = 0;
  double height = 0;
  double width = 0;

  void initPos(double? x, double? y, double h, double w) {
    posX = x ?? 0;
    posY = y ?? 10;
    height = h;
    width = w;
  }

  void walkRight() {
    posX += width;
  }

  void walkLeft() {
    posX -= width;
  }

  void walkTop() {
    posX -= height;
  }

  void walkBot() {
    posY += height;
  }

  @override
  String toString() {
    return "x: $posX y: $posY height: $height width: $width";
  }
}
