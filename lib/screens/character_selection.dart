import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:halloween_battle/core/character_details.dart';
import 'package:halloween_battle/models/game_state.dart';
import 'package:provider/provider.dart';

class CharacterSelection extends StatelessWidget {
  const CharacterSelection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: characterDetailsMap.length,
          itemBuilder: (context, index) {
            final charDetails = characterDetailsMap.entries.elementAt(index);
            return Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 8,
              ),
              child: GestureDetector(
                onTap: () {
                  Provider.of<GameState>(context, listen: false)
                      .currentCharacterType = charDetails.key;
                },
                child: GridTile(
                  header: Text(
                    charDetails.key.toString().split('.')[1].toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 25),
                  ),
                  child: FutureBuilder<SpriteAnimation>(
                    future: SpriteAnimation.load(
                      charDetails.value.assetPath,
                      SpriteAnimationData.sequenced(
                        amount: charDetails.value.amount,
                        stepTime: charDetails.value.stepTime,
                        textureSize: charDetails.value.textureSize,
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
                            height: charDetails.value.textureSize.y * 5,
                            width: charDetails.value.textureSize.x * 5,
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
                                anchor: Anchor.topCenter,
                              ),
                            ),
                          );
                      }
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
