import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:halloween_battle/core/game.dart';
import 'package:halloween_battle/models/game_state.dart';

enum CharacterType { ghost, mummy, witch, pumpkin }
enum AnimationType { idle }
enum CharacterAction { charge, shield, primaryAttack, specialAttack }

class CharacterDetails {
  final double stepTime;
  final String assetPath;
  final int amount;
  final Vector2 textureSize;

  const CharacterDetails({
    required this.assetPath,
    required this.stepTime,
    required this.amount,
    required this.textureSize,
  });
}

Map<CharacterType, CharacterDetails> characterDetailsMap = {
  CharacterType.ghost: CharacterDetails(
    assetPath: 'ghost.png',
    stepTime: 0.3,
    amount: 4,
    textureSize: Vector2(37, 45),
  ),
  CharacterType.mummy: CharacterDetails(
    assetPath: 'vampire.png',
    stepTime: 0.3,
    amount: 4,
    textureSize: Vector2(22, 35),
  ),
  CharacterType.witch: CharacterDetails(
    assetPath: 'werewolf.png',
    stepTime: 0.3,
    amount: 4,
    textureSize: Vector2(28, 42),
  ),
  CharacterType.pumpkin: CharacterDetails(
    assetPath: 'witch.png',
    stepTime: 0.3,
    amount: 4,
    textureSize: Vector2.all(50),
  ),
};

class Character extends PositionComponent with HasGameRef<HalloweenBattleGame> {
  final PlayerType playerType;
  CharacterType characterType;
  late SpriteAnimationGroupComponent<AnimationType>
      _spriteAnimationGroupComponent;

  Character(this.characterType, this.playerType);

  @override
  Future<void>? onLoad() async {
    final characterDetails = characterDetailsMap[characterType]!;

    final idleAnimation = await SpriteAnimation.load(
      characterDetails.assetPath,
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: characterDetails.stepTime,
        textureSize: characterDetails.textureSize,
      ),
    );

    _spriteAnimationGroupComponent =
        SpriteAnimationGroupComponent<AnimationType>(
      current: AnimationType.idle,
      size: characterDetails.textureSize,
      animations: {AnimationType.idle: idleAnimation},
    );
    _spriteAnimationGroupComponent.anchor = Anchor.center;
    anchor = Anchor.center;

    if (playerType == PlayerType.player1) {
      _spriteAnimationGroupComponent.flipHorizontallyAroundCenter();
    }

    add(_spriteAnimationGroupComponent);

    TextPaint textPaint = TextPaint(
      config: TextPaintConfig(fontSize: 8.0, color: Colors.yellow.shade400),
    );

    final name = TextComponent(
      playerType.toString().split('.')[1].toUpperCase(),
      size: Vector2(10, 20),
      textRenderer: textPaint,
    )..anchor = Anchor.center;

    name.position = _spriteAnimationGroupComponent.position -
        Vector2(0, characterDetails.textureSize.y / 1.5);

    add(name);

    return super.onLoad();
  }
}
