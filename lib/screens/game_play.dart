import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:halloween_battle/widgets/game_over.dart';
import 'package:halloween_battle/widgets/hud.dart';

import '../main.dart';

class GamePlay extends StatelessWidget {
  const GamePlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: game,
        initialActiveOverlays: const [HUD.id],
        overlayBuilderMap: {
          HUD.id: (context, gameRef) => const HUD(),
          GameOver.id: (context, gameRef) => const GameOver(),
        },
      ),
    );
  }
}
