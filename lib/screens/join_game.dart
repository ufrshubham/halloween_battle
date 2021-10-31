import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:halloween_battle/models/game_state.dart';
import 'package:halloween_battle/screens/game_play.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';

class JoinGame extends StatelessWidget {
  const JoinGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Join Game',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Center(
        child: TextField(
          decoration: const InputDecoration(
            hintText: 'Game ID',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          ),
          style: const TextStyle(fontSize: 30),
          textAlign: TextAlign.center,
          maxLines: 1,
          keyboardType: TextInputType.number,
          onSubmitted: (value) async {
            final supabase = Provider.of<Supabase>(context, listen: false);
            final gameState = Provider.of<GameState>(context, listen: false);
            final response = await supabase.client
                .from(GameState.tableName + GameState.whereIdIs)
                .update({
                  GameState.player2CharacterTypeStr:
                      gameState.currentCharacterType.index,
                })
                .eq('id', value)
                .execute();

            if (response.status == 200 &&
                response.error == null &&
                response.data != null &&
                (response.data.length == 1)) {
              final gameState = Provider.of<GameState>(context, listen: false);
              gameState.currentPlayerType = PlayerType.player2;
              gameState.gameId = int.parse(value);
              gameState.player2CharacterType = gameState.currentCharacterType;
              gameState.updateFromMap(response.data[0]);

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) {
                    game.gameState = gameState;

                    return const GamePlay();
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
