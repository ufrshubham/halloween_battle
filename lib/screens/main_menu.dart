import 'package:flutter/material.dart';
import 'package:halloween_battle/screens/character_selection.dart';
import 'package:halloween_battle/screens/host_game.dart';
import 'package:halloween_battle/screens/join_game.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                child: const Text('Host')),
            OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const JoinGame(),
                    ),
                  );
                },
                child: const Text('Join')),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CharacterSelection(),
                  ),
                );
              },
              child: const Text('Character'),
            ),
          ],
        ),
      ),
    );
  }
}
