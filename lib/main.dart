import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:halloween_battle/core/audio_manager.dart';
import 'package:halloween_battle/core/game.dart';
import 'package:halloween_battle/screens/game_play.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;
import 'package:halloween_battle/secrets.dart';

final game = HalloweenBattleGame();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  await AudioManager.instance
      .init(['battleunderthemoonlight.ogg', 'witchsworkshop.ogg']);
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
              ],
              child: MaterialApp(
                title: 'Flutter Demo',
                themeMode: ThemeMode.dark,
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  scaffoldBackgroundColor: Colors.black,
                  fontFamily: 'Fruktur',
                ),
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
    return GamePlay();
  }
}
