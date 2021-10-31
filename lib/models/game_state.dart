import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:halloween_battle/core/character.dart';
import 'package:halloween_battle/core/character_details.dart';
import 'package:halloween_battle/core/game.dart';
import 'package:supabase/supabase.dart';
// ignore: implementation_imports
import 'package:supabase/src/supabase_realtime_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum PlayerType { player1, player2 }

class GameState extends ChangeNotifier {
  late Supabase supabase;
  late HalloweenBattleGame gameRef;
  SupabaseRealtimeClient? realtimeClient;

  static const String player1AttackKey = 'p1';
  static const String player2AttackKey = 'p2';
  static const String player1CharacterTypeStr = 'p1Character';
  static const String player2CharacterTypeStr = 'p2Character';
  static const String whereIdIs = ':id=eq.';
  static const String tableName = 'HalloweenBattleBoard2P';
  static const String nextTurnKey = 'next-turn';

  Random random = Random();

  void setAsHost(int id) {
    gameId = id;
    currentPlayerType = PlayerType.player1;
    player1CharacterType = currentCharacterType;
    player2CharacterType = null;
  }

  void setAsGuest(int id, Map<String, dynamic> map) {
    gameId = id;
    currentPlayerType = PlayerType.player2;
    player2CharacterType = currentCharacterType;
    player1CharacterType =
        CharacterType.values.elementAt(map[player1CharacterTypeStr]);
  }

  bool _isMyTurn = false;
  bool get isMyTurn => _isMyTurn;
  set isMyTurn(bool flag) {
    _isMyTurn = flag;
    notifyListeners();
  }

  String? _otherAttackKey;
  PlayerType? _otherPlayerType;

  String? _currentAttackKey;
  PlayerType? _currentPlayerType;
  PlayerType? get currentPlayerType => _currentPlayerType;
  set currentPlayerType(PlayerType? type) {
    _currentPlayerType = type;
    switch (type) {
      case PlayerType.player1:
        _isMyTurn = true;
        _otherPlayerType = PlayerType.player2;
        _currentAttackKey = GameState.player1AttackKey;
        _otherAttackKey = GameState.player2AttackKey;
        break;
      case PlayerType.player2:
        _isMyTurn = false;
        _otherPlayerType = PlayerType.player1;
        _currentAttackKey = GameState.player2AttackKey;
        _otherAttackKey = GameState.player1AttackKey;
        break;
      case null:
        _isMyTurn = false;
        _otherPlayerType = null;
        _currentAttackKey = null;
        _otherAttackKey = null;
        break;
    }
  }

  CharacterType _currentCharacterType = CharacterType.ghost;

  CharacterType get currentCharacterType => _currentCharacterType;
  set currentCharacterType(CharacterType type) {
    if (type != _currentCharacterType) {
      _currentCharacterType = type;
      notifyListeners();
    }
  }

  CharacterType player1CharacterType = CharacterType.ghost;
  CharacterType? player2CharacterType;

  int _gameId = -1;

  set gameId(int id) {
    if (_gameId != id) {
      _gameId = id;
      _registerListener();
    }
  }

  void _registerListener() {
    realtimeClient?.subscription.unsubscribe();
    realtimeClient = supabase.client
        .from(tableName + whereIdIs + '$_gameId')
        .on(SupabaseEventTypes.update, (payload) {
      if (payload.newRecord != null) {
        updateFromMap(payload.newRecord!);
      }
    });
    realtimeClient?.subscribe();
  }

  void updateFromMap(Map<String, dynamic> map) {
    if (map['id'] == _gameId) {
      final nextTurn = map['next-turn'];

      _isMyTurn = (nextTurn == currentPlayerType!.index);

      player2CharacterType =
          CharacterType.values.elementAt(map[player2CharacterTypeStr]);

      if (nextTurn == 0) {
        final attack = map['p2'];
        if (attack != null) {
          final p2Attack = CharacterAction.values.elementAt(attack);
          gameRef.player2DoAction(p2Attack, map);
        }
      } else if (nextTurn == 1) {
        final attack = map['p1'];
        if (attack != null) {
          final p1Attack = CharacterAction.values.elementAt(attack);
          gameRef.player1DoAction(p1Attack, map);
        }
      }

      notifyListeners();
    }
  }

  Future<void> requestAction(CharacterAction action) async {
    int p1HP = gameRef.player1.hp;
    int p1XP = gameRef.player1.xp;
    int p2HP = gameRef.player2.hp;
    int p2XP = gameRef.player2.xp;
    bool p1Shield = gameRef.player1.isShieldActivated;
    bool p2Shield = gameRef.player2.isShieldActivated;

    switch (action) {
      case CharacterAction.primaryAttack:
      case CharacterAction.specialAttack:
        final maxHP = characterDetailsMap[currentCharacterType]!
            .actions[action]!
            .maxHPGiven!;
        final minHP = characterDetailsMap[currentCharacterType]!
            .actions[action]!
            .minHPGiven!;
        final randomHP = (random.nextInt(maxHP - minHP) + minHP);

        if (currentPlayerType == PlayerType.player1) {
          p1Shield = false;
          p1XP -= characterDetailsMap[currentCharacterType]!
              .actions[action]!
              .xpNeeded!;
          p1XP = p1XP.clamp(0, 100);

          if (!gameRef.player2.isShieldActivated) {
            p2HP -= randomHP;
            p2HP = p2HP.clamp(0, 100);
          } else {
            p2Shield = false;
          }
        } else if (currentPlayerType == PlayerType.player2) {
          p2Shield = false;
          p2XP -= characterDetailsMap[currentCharacterType]!
              .actions[action]!
              .xpNeeded!;
          p2XP = p2XP.clamp(0, 100);

          if (!gameRef.player1.isShieldActivated) {
            p1HP -= randomHP;
            p1HP = p1HP.clamp(0, 100);
          } else {
            p1Shield = false;
          }
        }

        break;
      case CharacterAction.charge:
        final maxXP = characterDetailsMap[currentCharacterType]!
            .actions[action]!
            .maxXPGained!;
        final minXP = characterDetailsMap[currentCharacterType]!
            .actions[action]!
            .minXPGained!;
        final randomXP = (random.nextInt(maxXP - minXP) + minXP);

        final maxHP = characterDetailsMap[currentCharacterType]!
            .actions[action]!
            .maxHPGained!;
        final minHP = characterDetailsMap[currentCharacterType]!
            .actions[action]!
            .minHPGained!;
        final randomHP = (random.nextInt(maxHP - minHP) + minHP);

        if (currentPlayerType == PlayerType.player1) {
          p1XP += randomXP;
          p1XP = p1XP.clamp(0, 100);

          p1HP += randomHP;
          p1HP = p1HP.clamp(0, 100);
        } else if (currentPlayerType == PlayerType.player2) {
          p2XP += randomXP;
          p2XP = p2XP.clamp(0, 100);

          p2HP += randomHP;
          p2HP = p2HP.clamp(0, 100);
        }

        break;
      case CharacterAction.shield:
        if (currentPlayerType == PlayerType.player1) {
          p1Shield = true;
          p1XP -= characterDetailsMap[currentCharacterType]!
              .actions[action]!
              .xpNeeded!;
          p1XP = p1XP.clamp(0, 100);
        } else if (currentPlayerType == PlayerType.player2) {
          p2Shield = true;
          p2XP -= characterDetailsMap[currentCharacterType]!
              .actions[action]!
              .xpNeeded!;
          p2XP = p2XP.clamp(0, 100);
        }
        break;
    }

    await supabase.client
        .from(GameState.tableName + GameState.whereIdIs + _gameId.toString())
        .update({
      _currentAttackKey: action.index,
      GameState.nextTurnKey: _otherPlayerType!.index,
      'p1HP': p1HP,
      'p1XP': p1XP,
      'p2HP': p2HP,
      'p2XP': p2XP,
      'p1Shield': p1Shield,
      'p2Shield': p2Shield,
    }).execute();
  }

  void reset() {
    player2CharacterType = null;
    _gameId = 0;

    if (currentPlayerType == PlayerType.player1) {
      supabase.client
          .from(tableName + whereIdIs + '$_gameId')
          .delete()
          .execute();
    }
    currentPlayerType = null;
    realtimeClient?.subscription.unsubscribe();
  }

  @override
  void dispose() {
    reset();
    realtimeClient?.subscription.unsubscribe();
    super.dispose();
  }
}
