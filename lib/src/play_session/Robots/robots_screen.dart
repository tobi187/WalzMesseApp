import 'package:flutter/material.dart';
import 'package:game_template/src/play_session/Robots/field.dart';
import 'package:provider/provider.dart';

import '../../style/palette.dart';

class RobotScreen extends StatelessWidget {
  const RobotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundPlaySession,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Field(),
        ),
      ),
    );
  }
}
