import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halloween_battle/core/audio_manager.dart';
import 'package:halloween_battle/core/character.dart';
import 'package:halloween_battle/core/character_details.dart';
import 'package:halloween_battle/models/game_state.dart';
import 'package:flame/parallax.dart';
import 'package:halloween_battle/widgets/game_over.dart';
import 'package:halloween_battle/widgets/hud.dart';

enum PointType { hp, xp }

class HalloweenBattleGame extends FlameGame with HasTappableComponents {
  GameState gameState = GameState();
  late Character player1;
  late Character player2;
  late Size deviceSize;

  double _fullRectWidth = 0;
  bool isGameOver = false;
  bool _isGameStarted = false;

  HalloweenBattleGame() {
    gameState.gameRef = this;
  }

  void statGame() {
    AudioManager.instance.stopBgm();
    AudioManager.instance.startBgm('battleunderthemoonlight.ogg');
    
    player1 = Character(gameState.player1CharacterType, PlayerType.player1);
    player2 = Character(gameState.player2CharacterType!, PlayerType.player2);

    player1.position = Vector2(64,
        (size.y - characterDetailsMap[player1.characterType]!.textureSize.y));

    _fullRectWidth = (camera.canvasSize.x / 2) - 10 - 10;

    player2.position = Vector2(size.x - 64,
        (size.y - characterDetailsMap[player1.characterType]!.textureSize.y));

    add(player1);
    add(player2);
    overlays.add(HUD.id);
    _isGameStarted = true;
  }

  void removePlayers() {
    player1.hp = 0;
    player1.xp = 0;
    player2.hp = 0;
    player2.xp = 0;
    player1.removeFromParent();
    player2.removeFromParent();
  }

  @override
  Future<void>? onLoad() async {
    camera.viewport =
        FixedResolutionViewport(Vector2(deviceSize.width, deviceSize.height));
    final parallaxComponent = await ParallaxComponent.load(
      [ParallaxImageData('2_game_background.png')],
      fill: LayerFill.width,
    );
    add(parallaxComponent);
    overlays.remove(GameOver.id);

    AudioManager.instance.startBgm('witchsworkshop.ogg');

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (_isGameStarted && !isGameOver) {
      if (player1.hp == 0 || player2.hp == 0) {
        isGameOver = true;
        overlays.remove(HUD.id);
        overlays.add(GameOver.id);
      }
    }
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (_isGameStarted) {
      canvas.drawRRect(
        _pointsToRRect(player1.hp.toDouble(), PlayerType.player1, PointType.hp),
        Paint()..color = Colors.red,
      );
      canvas.drawRRect(
        _pointsToRRect(player1.xp.toDouble(), PlayerType.player1, PointType.xp),
        Paint()..color = Colors.blue,
      );

      canvas.drawRRect(
        _pointsToRRect(player2.hp.toDouble(), PlayerType.player2, PointType.hp),
        Paint()..color = Colors.red,
      );

      canvas.drawRRect(
        _pointsToRRect(player2.xp.toDouble(), PlayerType.player2, PointType.xp),
        Paint()..color = Colors.blue,
      );
    }
  }

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

  void player1DoAction(CharacterAction action, Map<String, dynamic> map) {
    player1.doAction(action, player2, map);
  }

  void player2DoAction(CharacterAction action, Map<String, dynamic> map) {
    player2.doAction(action, player1, map);
  }
}
