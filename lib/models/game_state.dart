import 'package:flutter/cupertino.dart';
import 'package:halloween_battle/core/character.dart';
import 'package:halloween_battle/core/game.dart';
import 'package:supabase/supabase.dart';
// ignore: implementation_imports
import 'package:supabase/src/supabase_realtime_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum PlayerType { player1, player2 }

class GameState extends ChangeNotifier {
  final Supabase supabase;
  final HalloweenBattleGame gameRef;
  SupabaseRealtimeClient? realtimeClient;
  late Size deviceSize;

  static const String player1AttackKey = 'p1';
  static const String player2AttackKey = 'p2';
  static const String player1CharacterTypeStr = 'p1Character';
  static const String player2CharacterTypeStr = 'p2Character';
  static const String whereIdIs = ':id=eq.';
  static const String tableName = 'HalloweenBattleBoard2P';

  PlayerType? currentPlayerType;
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

  GameState({
    required this.supabase,
    required this.gameRef,
    required CharacterType characterType,
  }) {
    _currentCharacterType = characterType;
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
      final p1Attack = map['p1'];
      final p2Attack = map['p2'];
      final nextTurn = map['next-turn'];

      player2CharacterType =
          CharacterType.values.elementAt(map[player2CharacterTypeStr]);

      if (nextTurn == 1) {
        gameRef.player2DoAction(CharacterAction.charge);
      } else if (nextTurn == 2) {
        gameRef.player1DoAction(CharacterAction.charge);
      }

      notifyListeners();
    }
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
  }

  @override
  void dispose() {
    reset();
    realtimeClient?.subscription.unsubscribe();
    super.dispose();
  }
}
