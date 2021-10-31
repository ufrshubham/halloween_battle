import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:halloween_battle/core/character_details.dart';
import 'package:halloween_battle/core/game.dart';
import 'package:halloween_battle/models/game_state.dart';
import 'package:halloween_battle/screens/main_menu.dart';
import 'package:provider/provider.dart';

class CharacterSelection extends StatelessWidget {
  static const String id = 'CharacterSelection';
  final HalloweenBattleGame gameRef;
  const CharacterSelection({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: characterDetailsMap.length,
              itemBuilder: (context, index) {
                final charDetails =
                    characterDetailsMap.entries.elementAt(index);
                return Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 8,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      gameRef.gameState.currentCharacterType = charDetails.key;
                    },
                    child: GridTile(
                      footer: Text(
                        charDetails.key.toString().split('.')[1].toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.yellow.shade300,
                        ),
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
                                          style:
                                              gameState.currentCharacterType ==
                                                      charDetails.key
                                                  ? BorderStyle.solid
                                                  : BorderStyle.none,
                                        ),
                                      ),
                                      child: child,
                                    );
                                  },
                                  child: SpriteAnimationWidget(
                                    animation:
                                        spriteAnimationSnapshot.requireData,
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
          OutlinedButton(
            onPressed: () {
              gameRef.overlays.remove(CharacterSelection.id);
              gameRef.overlays.add(MainMenu.id);
            },
            child: const Text(
              'Back',
              style: TextStyle(fontSize: 25),
            ),
          )
        ],
      ),
    );
  }
}
