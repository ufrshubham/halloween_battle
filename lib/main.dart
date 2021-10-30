import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:halloween_battle/core/character.dart';
import 'package:halloween_battle/core/game.dart';
import 'package:halloween_battle/models/game_state.dart';
import 'package:halloween_battle/screens/main_menu.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:halloween_battle/secrets.dart';

final game = HalloweenBattleGame();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureProvider<Supabase?>(
      lazy: false,
      initialData: null,
      create: (_) {
        return Supabase.initialize(url: Secrets.url, anonKey: Secrets.anonKey);
      },
      builder: (_, child) {
        return Consumer<Supabase?>(builder: (_, supabase, child) {
          if (supabase != null) {
            return MultiProvider(
              providers: [
                Provider<Supabase>.value(value: supabase),
                ChangeNotifierProvider<GameState>(
                  lazy: false,
                  create: (context) => GameState(
                    supabase: Provider.of<Supabase>(context, listen: false),
                    gameRef: game,
                    characterType: CharacterType.ghost,
                  ),
                )
              ],
              child: MaterialApp(
                title: 'Flutter Demo',
                themeMode: ThemeMode.dark,
                darkTheme: ThemeData.dark(),
                home: const HalloweenBattle(),
              ),
            );
          } else {
            return MaterialApp(
              title: 'Flutter Demo',
              themeMode: ThemeMode.dark,
              darkTheme: ThemeData.dark(),
              home: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
      },
    );
  }
}

class HalloweenBattle extends StatelessWidget {
  const HalloweenBattle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MainMenu();
    // return Scaffold(
    //   body: Consumer<Supabase?>(
    //     builder: (_, supabase, child) {
    //       if (supabase != null) {
    //         return Provider<GameState>(
    //           create: (_) => GameState(supabase: supabase, gameRef: game),
    //           dispose: (_, gameState) {
    //             gameState.dispose();
    //           },
    //           builder: (_, child) {
    //             return GameWidget(
    //               game: game,
    //             );
    //           },
    //         );
    //       } else {
    //         return const CircularProgressIndicator();
    //       }
    //     },
    //   ),
    // );
  }
}
