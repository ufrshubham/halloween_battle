import 'package:flutter/material.dart';
import 'package:halloween_battle/core/audio_manager.dart';
import 'package:halloween_battle/core/game.dart';
import 'package:halloween_battle/models/game_state.dart';
import 'package:halloween_battle/screens/main_menu.dart';

class GameOver extends StatelessWidget {
  static const String id = 'GameOver';
  final HalloweenBattleGame gameRef;

  const GameOver({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlayer1Dead = gameRef.player1.hp == 0;
    bool isPlayer2Dead = gameRef.player2.hp == 0;
    final gameState = gameRef.gameState;

    bool isCurrentPlayerDead = false;
    if (gameState.currentPlayerType == PlayerType.player1) {
      isCurrentPlayerDead = isPlayer1Dead;
    } else if (gameState.currentPlayerType == PlayerType.player2) {
      isCurrentPlayerDead = isPlayer2Dead;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isCurrentPlayerDead ? 'You lost!' : 'You win!',
            style: const TextStyle(fontSize: 25),
          ),
          OutlinedButton(
            onPressed: () {
              gameState.reset();
              gameRef.removePlayers();
              gameRef.overlays.remove(GameOver.id);
              gameRef.overlays.add(MainMenu.id);
              AudioManager.instance.stopBgm();
              AudioManager.instance.startBgm('witchsworkshop.ogg');
            },
            child: const Text('Main Menu', style: TextStyle(fontSize: 25)),
          )
        ],
      ),
    );
  }
}
