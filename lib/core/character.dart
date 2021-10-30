import 'package:flame/components.dart';
import 'package:halloween_battle/core/game.dart';

enum CharacterType { ghost, mummy, witch, pumpkin }
enum AnimationType { idle }
enum CharacterAction { charge, shield, primaryAttack, specialAttack }

class CharacterDetails {
  final double stepTime;
  final String assetPath;
  final int amount;

  const CharacterDetails(
      {required this.assetPath, required this.stepTime, required this.amount});
}

const Map<CharacterType, CharacterDetails> characterDetailsMap = {
  CharacterType.ghost: CharacterDetails(
      assetPath: 'HalloweenGhost.png', stepTime: 0.3, amount: 7),
  CharacterType.mummy: CharacterDetails(
      assetPath: 'HalloweenMummy.png', stepTime: 0.5, amount: 2),
  CharacterType.witch: CharacterDetails(
      assetPath: 'HalloweenWitch.png', stepTime: 0.5, amount: 2),
  CharacterType.pumpkin: CharacterDetails(
      assetPath: 'HalloweenPumpkin.png', stepTime: 0.5, amount: 2),
};

class Character extends PositionComponent with HasGameRef<HalloweenBattleGame> {
  CharacterType characterType;
  late SpriteAnimationGroupComponent<AnimationType>
      _spriteAnimationGroupComponent;

  Character(this.characterType);

  @override
  Future<void>? onLoad() async {
    final characterDetails = characterDetailsMap[characterType]!;

    final idleAnimation = await SpriteAnimation.load(
      characterDetails.assetPath,
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: characterDetails.stepTime,
        textureSize: Vector2.all(32),
      ),
    );

    _spriteAnimationGroupComponent =
        SpriteAnimationGroupComponent<AnimationType>(
      current: AnimationType.idle,
      size: Vector2.all(32),
      animations: {AnimationType.idle: idleAnimation},
    );

    add(_spriteAnimationGroupComponent);

    return super.onLoad();
  }
}
