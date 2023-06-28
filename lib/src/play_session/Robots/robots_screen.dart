import 'package:flutter/material.dart';
import 'package:game_template/src/game_internals/full_game_state.dart';
import 'package:game_template/src/level_selection/robot_levels.dart';
import 'package:game_template/src/play_session/Robots/editor_screen.dart';
import 'package:game_template/src/play_session/Robots/field.dart';
import 'package:provider/provider.dart';

import '../../style/palette.dart';

class RobotScreen extends StatelessWidget {
  const RobotScreen({super.key, required this.level});
  final RobotGameLevel level;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundPlaySession,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
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
                      context.read<FullGameState>().isAnimating = true;
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
          ),
        ),
      ),
    );
  }
}
