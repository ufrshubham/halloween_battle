import 'package:flutter/material.dart';
import 'package:halloween_battle/core/game.dart';
import 'package:halloween_battle/models/game_state.dart';
import 'package:halloween_battle/screens/main_menu.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JoinGame extends StatelessWidget {
  static const String id = 'JoinGame';
  final HalloweenBattleGame gameRef;
  const JoinGame({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameState = gameRef.gameState;
    gameState.supabase = Provider.of<Supabase>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/2_game_background.png'),
              fit: BoxFit.fitWidth),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Game ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                style: const TextStyle(fontSize: 35),
                textAlign: TextAlign.center,
                maxLines: 1,
                keyboardType: TextInputType.number,
                keyboardAppearance: Brightness.dark,
                onSubmitted: (value) async {
                  final gameState = gameRef.gameState;
                  final supabase = gameState.supabase;

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
                    gameState.setAsGuest(int.parse(value), response.data[0]);
                    gameRef.statGame();

                    Navigator.of(context).pop();
                  }
                },
              ),
              OutlinedButton(
                onPressed: () {
                  gameRef.overlays.add(MainMenu.id);
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Back',
                  style: TextStyle(fontSize: 35),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
