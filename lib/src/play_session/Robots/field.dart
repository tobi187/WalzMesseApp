import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_template/src/game_internals/robot_state.dart';
import 'package:game_template/src/game_internals/robot_ui.dart';
import 'package:game_template/src/play_session/Robots/editor_screen.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class Field extends StatelessWidget {
  Field({super.key});

  late final GlobalKey columnKey = GlobalKey();

  final rui = RobotUiHelpers();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RobotState(),
      child: Column(
        children: [
          Expanded(
            //flex: 4,
            child: Stack(
              fit: StackFit.expand,
              children: [
                GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 8,
                  children: [
                    Container(
                      key: columnKey,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(strokeAlign: -1, width: 2),
                        ),
                      ),
                    ),
                    ...rui.borders
                        .skip(1)
                        .map(
                          (border) => Container(
                            decoration: border,
                          ),
                        )
                        .toList(growable: false)
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
                                () => robotState.initPos(columnKey
                                    .currentContext
                                    ?.findRenderObject()));
                          },
                        ),
                ),
                // Positioned(
                //   bottom: 5,
                //   child: FilledButton(
                //     child: const Text("Start"),
                //     onPressed: () {
                //       Provider.of<RobotState>(context)
                //           .initPos(columnKey.currentContext?.findRenderObject());
                //     },
                //   ),
                // ),
              ],
            ),
          ),
          Expanded(
            //flex: 6,
            child: EditorScreen(),
          )
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
