import 'package:flutter/material.dart';
import 'package:halloween_battle/core/character.dart';
import 'package:halloween_battle/models/game_state.dart';
import 'package:provider/provider.dart';

class HUD extends StatelessWidget {
  static const String id = 'HUD';

  const HUD({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Consumer<GameState>(
        builder: (context, gameState, child) {
          final currentPlayer =
              (gameState.currentPlayerType == PlayerType.player1)
                  ? gameState.gameRef.player1
                  : gameState.gameRef.player2;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                child: const Text('Attack', style: TextStyle(fontSize: 25)),
                onPressed: gameState.isMyTurn &&
                        (currentPlayer
                            .hasEnoughXP(CharacterAction.primaryAttack))
                    ? () async {
                        gameState.isMyTurn = false;
                        await gameState
                            .requestAction(CharacterAction.primaryAttack);
                      }
                    : null,
              ),
              OutlinedButton(
                child: const Text('Charge', style: TextStyle(fontSize: 25)),
                onPressed: gameState.isMyTurn
                    ? () async {
                        gameState.isMyTurn = false;
                        await gameState.requestAction(CharacterAction.charge);
                      }
                    : null,
              ),
              OutlinedButton(
                child: const Text('Shield', style: TextStyle(fontSize: 25)),
                onPressed: (gameState.isMyTurn &&
                        (currentPlayer.hasEnoughXP(CharacterAction.shield)))
                    ? () async {
                        gameState.isMyTurn = false;
                        await gameState.requestAction(CharacterAction.shield);
                      }
                    : null,
              ),
              OutlinedButton(
                child: const Text('Special', style: TextStyle(fontSize: 25)),
                onPressed: (gameState.isMyTurn &&
                        (currentPlayer
                            .hasEnoughXP(CharacterAction.specialAttack)))
                    ? () async {
                        gameState.isMyTurn = false;
                        await gameState
                            .requestAction(CharacterAction.specialAttack);
                      }
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
