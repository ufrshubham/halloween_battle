import 'package:flutter/material.dart';
import 'package:halloween_battle/core/game.dart';

import 'package:halloween_battle/screens/character_selection.dart';
import 'package:halloween_battle/screens/host_game.dart';
import 'package:halloween_battle/screens/join_game.dart';

class MainMenu extends StatelessWidget {
  static const String id = 'MainMenu';
  final HalloweenBattleGame gameRef;
  const MainMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
              onPressed: () {
                gameRef.overlays.remove(MainMenu.id);
                gameRef.overlays.add(HostGame.id);
              },
              child: const Text(
                'Host',
                style: TextStyle(fontSize: 35),
              )),
          OutlinedButton(
            onPressed: () {
              gameRef.overlays.remove(MainMenu.id);
              // gameRef.overlays.add(JoinGame.id);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => JoinGame(gameRef: gameRef)));
            },
            child: const Text(
              'Join',
              style: TextStyle(fontSize: 35),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              gameRef.overlays.remove(MainMenu.id);
              gameRef.overlays.add(CharacterSelection.id);
            },
            child: const Text(
              'Character',
              style: TextStyle(fontSize: 35),
            ),
          ),
        ],
      ),
    );
  }
}
