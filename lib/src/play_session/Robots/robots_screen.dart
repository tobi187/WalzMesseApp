import 'package:flutter/material.dart';
import 'package:game_template/src/game_internals/editor_state.dart';
import 'package:game_template/src/game_internals/robot_state.dart';
import 'package:game_template/src/level_selection/robot_levels.dart';
import 'package:game_template/src/play_session/Robots/editor_screen.dart';
import 'package:game_template/src/play_session/Robots/field.dart';
import 'package:game_template/src/style/confetti.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../style/palette.dart';

class RobotScreen extends StatelessWidget {
  RobotScreen({super.key, required this.level});
  final RobotGameLevel level;

  bool _duringCelebration = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EditorState>(create: (_) => EditorState()),
        ChangeNotifierProvider<RobotState>(
            create: (_) => RobotState(
                  borders: level.borders,
                  onWin: () {
                    //GoRouter.of(context).pop();
                    _duringCelebration = true;
                  },
                  onFail: () {
                    //GoRouter.of(context).pop();
                  },
                ))
      ],
      builder: (context, child) => Scaffold(
        backgroundColor: palette.backgroundPlaySession,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Stack(
              children: [
                !_duringCelebration
                    ? Column(
                        children: [
                          Expanded(
                            child: Field(
                              level: level,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FilledButton(
                                onPressed: () {
                                  final rbState = context.read<RobotState>();
                                  rbState.reset();
                                  final edState = context.read<EditorState>();
                                  edState.reset();
                                },
                                child: const Text("Abc"),
                              ),
                              FilledButton(
                                onPressed: () async {
                                  final edState = context.read<EditorState>();
                                  final rbState = context.read<RobotState>();
                                  final commands = edState.startAnimation();
                                  await rbState.startAnimation(commands);
                                  // TODO: after animations finshes
                                },
                                child: const Text("Start"),
                              )
                            ],
                          ),
                          SizedBox(height: 8),
                          Expanded(
                            child: EditorScreen(),
                          )
                        ],
                      )
                    : SizedBox.expand(
                        child: Visibility(
                          visible: _duringCelebration,
                          child: IgnorePointer(
                            child: Confetti(
                              isStopped: !_duringCelebration,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
