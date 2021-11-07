import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:halloween_battle/core/character_details.dart';
import 'package:halloween_battle/core/game.dart';
import 'package:halloween_battle/models/game_state.dart';

enum CharacterType { ghost, vampire, werewolf, witch }
enum AnimationType { idle }
enum CharacterAction { primaryAttack, charge, shield, specialAttack }

class ActionCosts {
  final int? minHPGiven;
  final int? maxHPGiven;
  final int? xpNeeded;
  final int? minXPGained;
  final int? maxXPGained;
  final int? minHPGained;
  final int? maxHPGained;

  const ActionCosts({
    this.maxHPGiven,
    this.minHPGiven,
    this.xpNeeded,
    this.minXPGained,
    this.maxXPGained,
    this.minHPGained,
    this.maxHPGained,
  });
}

class CharacterDetails {
  final double stepTime;
  final String assetPath;
  final int amount;
  final Vector2 textureSize;
  final Map<CharacterAction, ActionCosts> actions;

  const CharacterDetails({
    required this.assetPath,
    required this.stepTime,
    required this.amount,
    required this.textureSize,
    required this.actions,
  });
}

class Character extends PositionComponent
    with HasGameRef<HalloweenBattleGame>, HasPaint {
  bool isShieldActivated = false;
  final PlayerType playerType;
  CharacterType characterType;
  late SpriteAnimationGroupComponent<AnimationType>
      _spriteAnimationGroupComponent;

  int hp = 100;
  int xp = 100;

  hasEnoughXP(CharacterAction action) {
    final xpNeeded =
        characterDetailsMap[characterType]!.actions[action]!.xpNeeded;
    if (xpNeeded != null) {
      return ((xpNeeded <= xp) && (hp > 0));
    } else {
      return true;
    }
  }

  Character(this.characterType, this.playerType);

  @override
  Future<void>? onLoad() async {
    paint = Paint()..color = Colors.red;
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

    String playerText = '';
    if (playerType == gameRef.gameState.currentPlayerType) {
      playerText = 'You';
    } else {
      playerText = 'Other';
    }

    final name = TextComponent(
      playerText,
      size: Vector2(10, 20),
      textRenderer: textPaint,
    )..anchor = Anchor.center;

    name.position = _spriteAnimationGroupComponent.position -
        Vector2(0, characterDetails.textureSize.y / 1.5);

    add(name);

    return super.onLoad();
  }

  void displayPoints(int points, bool isNegative) {
    TextPaint textPaint = TextPaint(
      config: const TextPaintConfig(fontSize: 15, color: Colors.red),
    );
    final name = TextComponent(
      isNegative ? '-$points' : '+$points',
      size: Vector2(10, 20),
      textRenderer: textPaint,
    )..anchor = Anchor.center;

    name.add(
      SequenceEffect(
        effects: [
          MoveEffect(path: [Vector2(0, -80)], duration: 0.8),
          OpacityEffect(
            opacity: 0,
            duration: 0.5,
          )
        ],
        onComplete: () {
          name.removeFromParent();
        },
      ),
    );

    add(name);
  }

  void doAction(
      CharacterAction action, Character other, Map<String, dynamic> map) {
    final p1HP = map['p1HP']!;
    final p1XP = map['p1XP']!;
    final p1Shield = map['p1Shield']!;

    final p2HP = map['p2HP']!;
    final p2XP = map['p2XP']!;
    final p2Shield = map['p2Shield']!;

    switch (action) {
      case CharacterAction.primaryAttack:
      case CharacterAction.specialAttack:
        final originalPosition = position.clone();
        gameRef.camera.shake(duration: 0.5, intensity: 2);
        add(
          MoveEffect(
            path: [other.position, originalPosition],
            duration: 1,
            curve: Curves.fastLinearToSlowEaseIn,
            onComplete: () {
              if (playerType == PlayerType.player1) {
                hp = p1HP;
                xp = p1XP;
                isShieldActivated = p1Shield;

                other.xp = p2XP;
                if (!other.isShieldActivated) {
                  other.displayPoints((other.hp - p2HP) as int, true);
                  other.hp = p2HP;
                }
                other.isShieldActivated = p2Shield;
              } else {
                other.xp = p1XP;
                xp = p2XP;
                hp = p2HP;
                isShieldActivated = p2Shield;

                if (!other.isShieldActivated) {
                  other.displayPoints((other.hp - p1HP) as int, true);
                  other.hp = p1HP;
                }
                other.isShieldActivated = p1Shield;
              }
            },
          ),
        );
        break;
      case CharacterAction.charge:
        if (playerType == PlayerType.player1) {
          displayPoints((p1HP - hp) as int, false);
          hp = p1HP;
          xp = p1XP;
          other.hp = p2HP;
          other.xp = p2XP;
        } else {
          displayPoints((p2HP - hp) as int, false);
          other.hp = p1HP;
          other.xp = p1XP;
          hp = p2HP;
          xp = p2XP;
        }
        break;
      case CharacterAction.shield:
        if (playerType == PlayerType.player1) {
          hp = p1HP;
          xp = p1XP;
          other.hp = p2HP;
          other.xp = p2XP;
          isShieldActivated = p1Shield;
        } else {
          other.hp = p1HP;
          other.xp = p1XP;
          hp = p2HP;
          xp = p2XP;
          isShieldActivated = p2Shield;
        }
        break;
    }
  }
}
