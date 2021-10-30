import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:halloween_battle/core/character.dart';
import 'package:halloween_battle/models/game_state.dart';
import 'package:provider/provider.dart';

class CharacterSelection extends StatelessWidget {
  const CharacterSelection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: characterDetailsMap.length,
          itemBuilder: (context, index) {
            final charDetails = characterDetailsMap.entries.elementAt(index);
            return SizedBox(
              width: MediaQuery.of(context).size.width / 4,
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 8,
                ),
                child: ListTile(
                  title: FutureBuilder<SpriteAnimation>(
                    future: SpriteAnimation.load(
                      charDetails.value.assetPath,
                      SpriteAnimationData.sequenced(
                        amount: charDetails.value.amount,
                        stepTime: charDetails.value.stepTime,
                        textureSize: Vector2.all(32),
                      ),
                    ),
                    builder: (context, spriteAnimationSnapshot) {
                      switch (spriteAnimationSnapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          return const CircularProgressIndicator();
                        case ConnectionState.done:
                          return SizedBox(
                            height: MediaQuery.of(context).size.width / 4,
                            width: MediaQuery.of(context).size.width / 4,
                            child: Consumer<GameState>(
                              builder: (context, gameState, child) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.red,
                                      style: gameState.currentCharacterType ==
                                              charDetails.key
                                          ? BorderStyle.solid
                                          : BorderStyle.none,
                                    ),
                                  ),
                                  child: child,
                                );
                              },
                              child: SpriteAnimationWidget(
                                animation: spriteAnimationSnapshot.requireData,
                              ),
                            ),
                          );
                      }
                    },
                  ),
                  subtitle: Text(
                    charDetails.key.toString().split('.')[1].toUpperCase(),
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    Provider.of<GameState>(context, listen: false)
                        .currentCharacterType = charDetails.key;
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
