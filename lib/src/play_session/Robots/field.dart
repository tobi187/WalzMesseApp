import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_template/src/game_internals/robot_state.dart';
import 'package:game_template/src/level_selection/robot_levels.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class Field extends StatelessWidget {
  Field({super.key, required this.level});

  final GlobalKey columnKey = GlobalKey();

  final RobotGameLevel level;

  @override
  Widget build(BuildContext context) { 
    return ChangeNotifierProvider(
      create: (context) => RobotState(
        onWin: () {
          GoRouter.of(context).pop();
        },
        onFail: () {
          GoRouter.of(context).pop();
        },
        borders: level.borders,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          GridView.count(
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 8,
            children: [
              Container(
                key: columnKey,
                decoration: level.getFirst(),
              ),
              ...level.getUiBordersWithoutFirst()
            ],
          ),
          Consumer<RobotState>(
            builder: (context, robotState, child) => robotState.isReady
                ? AnimatedPositioned(
                    width: robotState.width,
                    height: robotState.height,
                    left: robotState.xStart,
                    top: robotState.yStart,
                    duration: robotState.animationDuration,
                    child: Transform.rotate(
                      angle: robotState.rotation * pi / 180,
                      child: RiveAnimation.asset(
                        "assets/animations/tinkering.riv",
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                : StatefulWrapper(
                    onInit: () {
                      Future.delayed(
                          Duration(seconds: 1),
                          () => robotState.initPos(
                              columnKey.currentContext?.findRenderObject()));
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class StatefulWrapper extends StatefulWidget {
  final Function? onInit;
  const StatefulWrapper({super.key, required this.onInit});

  @override
  State<StatefulWrapper> createState() => _StatefulWrapperState();
}

class _StatefulWrapperState extends State<StatefulWrapper> {
  @override
  void initState() {
    if (widget.onInit != null) {
      widget.onInit!();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
