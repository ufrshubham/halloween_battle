import 'package:flutter/material.dart';
import 'package:halloween_battle/core/game.dart';
import 'package:halloween_battle/models/game_state.dart';
import 'package:halloween_battle/screens/main_menu.dart';
import 'package:halloween_battle/widgets/hud.dart';
import 'package:provider/provider.dart';
import 'package:supabase/supabase.dart' as supa;
import 'package:supabase_flutter/supabase_flutter.dart';

class HostGame extends StatelessWidget {
  static const String id = 'HostGame';
  final HalloweenBattleGame gameRef;

  const HostGame({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameState = gameRef.gameState;
    gameState.supabase = Provider.of<Supabase>(context, listen: false);
    return Center(
      child: FutureBuilder<supa.PostgrestResponse>(
        future: gameState.supabase.client.from(GameState.tableName).insert({
          GameState.player1CharacterTypeStr:
              gameState.currentCharacterType.index
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

                gameState.setAsHost(gameId);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Game Id: $gameId',
                      style: const TextStyle(fontSize: 35),
                    ),
                    Selector<GameState, bool>(
                      selector: (context, state) =>
                          (state.player2CharacterType != null),
                      builder: (context, hasPlayer2Joined, child) {
                        return OutlinedButton(
                          onPressed: hasPlayer2Joined
                              ? () {
                                  gameRef.statGame();
                                  gameRef.overlays.remove(HostGame.id);
                                  gameRef.overlays.add(HUD.id);
                                }
                              : null,
                          child: Text(
                            hasPlayer2Joined
                                ? 'Start game'
                                : 'Waiting for other player',
                            style: const TextStyle(fontSize: 35),
                          ),
                        );
                      },
                    ),
                    OutlinedButton(
                      onPressed: () {
                        gameRef.overlays.remove(HostGame.id);
                        gameRef.overlays.add(MainMenu.id);
                      },
                      child: const Text(
                        'Back',
                        style: TextStyle(fontSize: 35),
                      ),
                    ),
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
          }
        },
      ),
    );
  }
}
