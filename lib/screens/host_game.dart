import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:halloween_battle/models/game_state.dart';
import 'package:provider/provider.dart';
import 'package:supabase/supabase.dart' as supa;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';

class HostGame extends StatelessWidget {
  const HostGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<Supabase>(
          builder: (_, supabase, child) {
            return FutureBuilder<supa.PostgrestResponse>(
              future: supabase.client.from(GameState.tableName).insert({
                GameState.player1CharacterTypeStr:
                    Provider.of<GameState>(context, listen: false)
                        .currentCharacterType
                        .index
              }).execute(),
              builder: (_, responseSnapshot) {
                switch (responseSnapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return const CircularProgressIndicator();
                  case ConnectionState.done:
                    if (responseSnapshot.hasData &&
                        responseSnapshot.data != null &&
                        responseSnapshot.data!.data != null) {
                      final gameId = responseSnapshot.data!.data.first['id'];
                      final gameState =
                          Provider.of<GameState>(context, listen: false);
                      gameState.currentPlayerType = PlayerType.player1;
                      gameState.player1CharacterType =
                          gameState.currentCharacterType;
                      gameState.player2CharacterType = null;
                      gameState.gameId = gameId;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Game Id: $gameId'),
                          Selector<GameState, bool>(
                            selector: (context, state) =>
                                (state.player2CharacterType != null),
                            builder: (context, hasPlayer2Joined, child) {
                              return OutlinedButton(
                                onPressed: hasPlayer2Joined
                                    ? () {
                                        final gameState =
                                            Provider.of<GameState>(context,
                                                listen: false);
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(builder: (_) {
                                            game.gameState = gameState;

                                            return GameWidget(game: game);
                                          }),
                                        );
                                      }
                                    : null,
                                child: Text(
                                  hasPlayer2Joined
                                      ? 'Start game'
                                      : 'Waiting for other player',
                                ),
                              );
                            },
                          )
                        ],
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                }
              },
            );
          },
        ),
      ),
    );
  }
}
