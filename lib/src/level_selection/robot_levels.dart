import 'package:flutter/material.dart';

const robotLevels = [
  RobotGameLevel(
    number: 1,
    borders: [
      "t",
      "tb",
      "t",
      "tb",
      "t",
      "t",
      "tr",
      "tlr",
      "l",
      "tr",
      "bl",
      "tbr",
      "lr",
      "blr",
      "blr",
      "lr",
      "lr",
      "bl",
      "tr",
      "tbl",
      "",
      "tbr",
      "tl",
      "br",
      "blr",
      "tl",
      "b",
      "tr",
      "lr",
      "tlr",
      "l",
      "tbr",
      "tbl",
      "br",
      "tbl",
      "br",
      "bl",
      "b",
      "b",
      "tb"
    ],
    helpText: """""",
    tips: [""],
  )
];

class RobotGameLevel {
  final int number;
  final List<String> borders;
  final String helpText;
  final List<String> tips;
  static double borderWidth = 2;
  static double stAlign = -1;

  const RobotGameLevel(
      {required this.number,
      required this.borders,
      required this.helpText,
      required this.tips});

  BorderSide isBorder(int i, String s) {
    if (borders[i].contains(s)) {
      return BorderSide(strokeAlign: stAlign, width: borderWidth);
    } else {
      return BorderSide.none;
    }
  }

  BoxDecoration getFirst() {
    return BoxDecoration(
      border: Border(
        bottom: isBorder(0, "b"),
        top: isBorder(0, "t"),
        left: isBorder(0, "l"),
        right: isBorder(0, "r"),
      ),
    );
  }

  List<Container> getUiBordersWithoutFirst() {
    List<Container> decorations = [];
    for (var i = 1; i < borders.length; i++) {
      var dec = Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: isBorder(i, "b"),
            top: isBorder(i, "t"),
            left: isBorder(i, "l"),
            right: isBorder(i, "r"),
          ),
        ),
      );
      decorations.add(dec);
    }

    return decorations;
  }
}
