import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halloween_battle/core/character.dart';
import 'package:halloween_battle/models/game_state.dart';
import 'package:flame/parallax.dart';

enum PointType { hp, xp }

class HalloweenBattleGame extends FlameGame {
  late GameState gameState;
  late Character player1;
  late Character player2;

  double _player1HP = 100;
  double _player1XP = 100;

  double _player2HP = 100;
  double _player2XP = 100;

  double _fullRectWidth = 0;

  RRect _pointsToRRect(
      double points, PlayerType playerType, PointType pointType) {
    final rectWidth = ((points * _fullRectWidth) / 100);
    double xCoordinate = (playerType == PlayerType.player1)
        ? 10
        : (camera.canvasSize.x - rectWidth - 10);
    double yCoordinate = (pointType == PointType.hp) ? 10 : 25;
    const double rectHeight = 10;

    return RRect.fromRectAndRadius(
      Rect.fromLTWH(xCoordinate, yCoordinate, rectWidth, rectHeight),
      const Radius.circular(10),
    );
  }

  @override
  void onAttach() {
    player1 = Character(gameState.player1CharacterType, PlayerType.player1);
    player2 = Character(gameState.player2CharacterType!, PlayerType.player2);

    player1.position = Vector2(64,
        (size.y - characterDetailsMap[player1.characterType]!.textureSize.y));

    _fullRectWidth = (camera.canvasSize.x / 2) - 10 - 10;

    player2.position = Vector2(size.x - 64,
        (size.y - characterDetailsMap[player1.characterType]!.textureSize.y));

    add(player1);
    add(player2);
    super.onAttach();
  }

  @override
  void onDetach() {
    player1.removeFromParent();
    player2.removeFromParent();
    //gameState.reset();
    super.onDetach();
  }

  @override
  void onRemove() {
    // TODO: implement onRemove
    super.onRemove();
  }

  @override
  Future<void>? onLoad() async {
    camera.viewport = FixedResolutionViewport(
        Vector2(gameState.deviceSize.width, gameState.deviceSize.height));
    final parallaxComponent = await ParallaxComponent.load(
      [ParallaxImageData('1_game_background.png')],
      fill: LayerFill.width,
    );
    add(parallaxComponent);

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRRect(
      _pointsToRRect(_player1HP, PlayerType.player1, PointType.hp),
      Paint()..color = Colors.red,
    );
    canvas.drawRRect(
      _pointsToRRect(_player1XP, PlayerType.player1, PointType.xp),
      Paint()..color = Colors.blue,
    );

    canvas.drawRRect(
      _pointsToRRect(_player2HP, PlayerType.player2, PointType.hp),
      Paint()..color = Colors.red,
    );

    canvas.drawRRect(
      _pointsToRRect(_player2XP, PlayerType.player2, PointType.xp),
      Paint()..color = Colors.blue,
    );
  }

  void player1DoAction(CharacterAction action) {}
  void player2DoAction(CharacterAction action) {}
}
