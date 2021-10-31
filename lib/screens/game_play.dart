import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:halloween_battle/core/game.dart';
import 'package:halloween_battle/models/game_state.dart';
import 'package:halloween_battle/screens/character_selection.dart';
import 'package:halloween_battle/screens/host_game.dart';
import 'package:halloween_battle/screens/join_game.dart';
import 'package:halloween_battle/screens/main_menu.dart';
import 'package:halloween_battle/widgets/game_over.dart';
import 'package:halloween_battle/widgets/hud.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class GamePlay extends StatelessWidget {
  const GamePlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    game.deviceSize = MediaQuery.of(context).size / 3;
    return Scaffold(
      body: GameWidget(
        game: game,
        initialActiveOverlays: const [MainMenu.id],
        overlayBuilderMap: {
          MainMenu.id: (context, HalloweenBattleGame gameRef) => MainMenu(
                gameRef: gameRef,
              ),
          HostGame.id: (context, HalloweenBattleGame gameRef) =>
              ChangeNotifierProvider<GameState>.value(
                value: gameRef.gameState,
                child: HostGame(
                  gameRef: gameRef,
                ),
              ),
          JoinGame.id: (context, HalloweenBattleGame gameRef) => JoinGame(
                gameRef: gameRef,
              ),
          CharacterSelection.id: (context, HalloweenBattleGame gameRef) =>
              ChangeNotifierProvider<GameState>.value(
                value: gameRef.gameState,
                child: CharacterSelection(
                  gameRef: gameRef,
                ),
              ),
          HUD.id: (context, HalloweenBattleGame gameRef) =>
              ChangeNotifierProvider<GameState>.value(
                value: gameRef.gameState,
                child: const HUD(),
              ),
          GameOver.id: (context, HalloweenBattleGame gameRef) =>
              GameOver(gameRef: gameRef),
        },
      ),
    );
  }
}
