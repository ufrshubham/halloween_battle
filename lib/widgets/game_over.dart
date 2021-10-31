import 'package:flutter/material.dart';
import 'package:halloween_battle/models/game_state.dart';
import 'package:provider/provider.dart';

class GameOver extends StatelessWidget {
  static const String id = 'GameOver';
  const GameOver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    bool isPlayer1Dead = gameState.gameRef.player1.hp == 0;
    bool isPlayer2Dead = gameState.gameRef.player2.hp == 0;

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
              Navigator.of(context).pop();
            },
            child: const Text('Main Menu', style: TextStyle(fontSize: 25)),
          )
        ],
      ),
    );
  }
}
