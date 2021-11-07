import 'package:flame/components.dart';
import 'package:halloween_battle/core/character.dart';

Map<CharacterType, CharacterDetails> characterDetailsMap = {
  CharacterType.ghost: CharacterDetails(
    assetPath: 'ghost.png',
    stepTime: 0.3,
    amount: 4,
    textureSize: Vector2(37, 45),
    actions: const {
      CharacterAction.primaryAttack: ActionCosts(
        maxHPGiven: 20,
        minHPGiven: 10,
        xpNeeded: 20,
      ),
      CharacterAction.specialAttack: ActionCosts(
        maxHPGiven: 40,
        minHPGiven: 20,
        xpNeeded: 50,
      ),
      CharacterAction.charge: ActionCosts(
        maxXPGained: 50,
        minXPGained: 20,
        maxHPGained: 20,
        minHPGained: 10,
      ),
      CharacterAction.shield: ActionCosts(
        xpNeeded: 50,
      ),
    },
  ),
  CharacterType.vampire: CharacterDetails(
    assetPath: 'vampire.png',
    stepTime: 0.3,
    amount: 4,
    textureSize: Vector2(22, 35),
    actions: const {
      CharacterAction.primaryAttack: ActionCosts(
        maxHPGiven: 30,
        minHPGiven: 10,
        xpNeeded: 25,
      ),
      CharacterAction.specialAttack: ActionCosts(
        maxHPGiven: 70,
        minHPGiven: 15,
        xpNeeded: 60,
      ),
      CharacterAction.charge: ActionCosts(
        maxXPGained: 40,
        minXPGained: 20,
        maxHPGained: 15,
        minHPGained: 10,
      ),
      CharacterAction.shield: ActionCosts(
        xpNeeded: 50,
      ),
    },
  ),
  CharacterType.werewolf: CharacterDetails(
    assetPath: 'werewolf.png',
    stepTime: 0.3,
    amount: 4,
    textureSize: Vector2(28, 42),
    actions: const {
      CharacterAction.primaryAttack: ActionCosts(
        maxHPGiven: 30,
        minHPGiven: 20,
        xpNeeded: 15,
      ),
      CharacterAction.specialAttack: ActionCosts(
        maxHPGiven: 45,
        minHPGiven: 25,
        xpNeeded: 45,
      ),
      CharacterAction.charge: ActionCosts(
        maxXPGained: 35,
        minXPGained: 25,
        maxHPGained: 15,
        minHPGained: 10,
      ),
      CharacterAction.shield: ActionCosts(
        xpNeeded: 50,
      ),
    },
  ),
  CharacterType.witch: CharacterDetails(
    assetPath: 'witch.png',
    stepTime: 0.3,
    amount: 4,
    textureSize: Vector2.all(50),
    actions: const {
      CharacterAction.primaryAttack: ActionCosts(
        maxHPGiven: 25,
        minHPGiven: 20,
        xpNeeded: 20,
      ),
      CharacterAction.specialAttack: ActionCosts(
        maxHPGiven: 30,
        minHPGiven: 25,
        xpNeeded: 40,
      ),
      CharacterAction.charge: ActionCosts(
        maxXPGained: 50,
        minXPGained: 30,
        maxHPGained: 15,
        minHPGained: 10,
      ),
      CharacterAction.shield: ActionCosts(
        xpNeeded: 50,
      ),
    },
  ),
};
