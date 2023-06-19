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
  final _animationDuration = Duration(seconds: 1);

  final steps = ["forward", "forward", "right", "forward", "left", "forward"];

  bool get isReady => _isReady;
  bool get isAnimationPlaying => _isAnimationPlaying;
  double get width => _rPosition.width;
  double get height => _rPosition.height;
  double get xStart => _rPosition.posX;
  double get yStart => _rPosition.posY;
  double get rotation => _rPosition.rotation;
  Duration get animationDuration => _animationDuration;

  void step() {
    if (currentStep >= steps.length) {
      _isAnimationPlaying = false;
      return;
    }
    Duration dur = Duration(milliseconds: 300);
    switch (steps[currentStep]) {
      case "right":
        _rPosition.turnRight();
      case "left":
        _rPosition.turnLeft();
      case "forward":
        _rPosition.walk();
        dur = Duration(seconds: 1);
      default:
        throw Exception(steps[currentStep]);
    }
    notifyListeners();
    currentStep++;
    _logger.info("Current rotation: $rotation");
    Future.delayed(dur, step);
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
  double rotation = 0;

  void initPos(double? x, double? y, double h, double w) {
    posX = x ?? 0;
    posY = y ?? 10;
    height = h;
    width = w;
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
      case 90:
        posY += height;
      case 180:
        posX -= width;
      case 270:
        posY -= width;
      default:
        throw Exception("Rotation unknown");
    }
  }

  @override
  String toString() {
    return "x: $posX y: $posY height: $height width: $width";
  }
}
