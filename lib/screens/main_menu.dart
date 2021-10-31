import 'package:flutter/material.dart';
import 'package:halloween_battle/models/game_state.dart';
import 'package:halloween_battle/screens/character_selection.dart';
import 'package:halloween_battle/screens/host_game.dart';
import 'package:halloween_battle/screens/join_game.dart';
import 'package:provider/provider.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<GameState>(context, listen: false).deviceSize =
        MediaQuery.of(context).size / 3;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const HostGame(),
                    ),
                  );
                },
                child: const Text(
                  'Host',
                  style: TextStyle(fontSize: 25),
                )),
            OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const JoinGame(),
                    ),
                  );
                },
                child: const Text(
                  'Join',
                  style: TextStyle(fontSize: 25),
                )),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CharacterSelection(),
                  ),
                );
              },
              child: const Text(
                'Character',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
