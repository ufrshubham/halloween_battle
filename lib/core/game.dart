import 'package:flame/game.dart';
import 'package:halloween_battle/core/character.dart';
import 'package:halloween_battle/models/game_state.dart';

class HalloweenBattleGame extends FlameGame {
  late GameState gameState;
  late Character player1;
  late Character player2;

  @override
  void onAttach() {
    player1 = Character(gameState.player1CharacterType);
    player2 = Character(gameState.player2CharacterType!);
    player2.position = size / 2;

    add(player1);
    add(player2);
    super.onAttach();
  }

  @override
  void onDetach() {
    player1.removeFromParent();
    player2.removeFromParent();
    gameState.reset();
    super.onDetach();
  }

  @override
  Future<void>? onLoad() {
    camera.viewport = FixedResolutionViewport(Vector2(160, 90));
    return super.onLoad();
  }

  void player1DoAction(CharacterAction action) {}
  void player2DoAction(CharacterAction action) {}
}
