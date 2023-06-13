// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:game_template/src/game_internals/fortune_wheel_state.dart';
import 'package:game_template/src/settings/admin/admin_persistence.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../style/confetti.dart';
import '../style/palette.dart';

class FortuneWheelScreen extends StatefulWidget {
  const FortuneWheelScreen({super.key});

  @override
  State<FortuneWheelScreen> createState() => _FortuneWheelScreenState();
}

class _FortuneWheelScreenState extends State<FortuneWheelScreen> {
  static final _log = Logger('PlaySessionScreen');

  final _random = Random();

  final data = AdminPersistance();

  static const _celebrationDuration = Duration(milliseconds: 2000);

  static const _preCelebrationDuration = Duration(milliseconds: 500);

  bool _duringCelebration = false;

  final _wheelStream = StreamController<int>.broadcast();

  int _selectedItem = 0;

  bool hasLoaded = false;

  List<String> _wheelItems = [];

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FortuneWheelState(
            onWin: _playerWon,
          ),
        ),
      ],
      child: IgnorePointer(
        ignoring: _duringCelebration,
        child: Scaffold(
          backgroundColor: palette.backgroundPlaySession,
          body: hasLoaded
              ? Stack(
                  children: [
                    Center(
                      // This is the entirety of the "game".
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkResponse(
                              onTap: () =>
                                  GoRouter.of(context).push('/settings'),
                              child: Image.asset(
                                'assets/images/settings.png',
                                semanticLabel: 'Settings',
                              ),
                            ),
                          ),
                          const Spacer(),
                          Consumer<FortuneWheelState>(
                            builder: (context, levelState, child) => Flexible(
                              flex: 4,
                              child: FortuneWheel(
                                items: _wheelItems
                                    .map(createWheelElement)
                                    .toList(),
                                selected: _wheelStream.stream,
                                onFling: () {
                                  var randNum =
                                      _random.nextInt(_wheelItems.length);
                                  _selectedItem = randNum;
                                  _wheelStream.add(randNum);
                                },
                                animateFirst: false,
                                onAnimationEnd: () {
                                  _log.info(_wheelItems[_selectedItem]);
                                  if (_wheelItems[_selectedItem]
                                      .startsWith("Win")) {
                                    levelState.spinFinished("a");
                                  } else {
                                    levelState.spinFinished(null);
                                  }
                                },
                              ),
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: () => GoRouter.of(context).go("/"),
                                child: const Text('Back'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 50)
                        ],
                      ),
                    ),
                    SizedBox.expand(
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
                )
              : Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 50,
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> getItems() async {
    _wheelItems = await data.getFortuneWheelOptions();
    setState(() {
      hasLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getItems();
  }

  @override
  void dispose() {
    _wheelStream.close();
    super.dispose();
  }

  Future<void> _playerWon() async {
    _log.info('Level 1 won');

    // Let the player see the game just after winning for a bit.
    await Future<void>.delayed(_preCelebrationDuration);
    if (!mounted) return;

    setState(() {
      _duringCelebration = true;
    });

    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.congrats);

    /// Give the player some time to see the celebration animation.
    await Future<void>.delayed(_celebrationDuration);
    if (!mounted) return;

    setState(() {
      _duringCelebration = false;
    });

    // GoRouter.of(context).go('/play/won', extra: {'score': 0});
  }

  FortuneItem createWheelElement(String text) {
    return FortuneItem(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: text[0],
            style: TextStyle(
              fontFamily: 'Permanent Marker',
              fontSize: 35,
              height: 1,
            ),
            children: text.characters.indexed
                .skip(1)
                .map((e) => TextSpan(
                      text: e.$2,
                      style: TextStyle(
                        fontFamily: 'Permanent Marker',
                        fontSize: 35.0 + e.$1 * 7,
                        height: 1,
                      ),
                    ))
                .toList()),
      ),
    );
  }
}
