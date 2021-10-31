import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  AudioManager._internal();

  static AudioManager _instance = AudioManager._internal();

  static AudioManager get instance => _instance;

  Future<void> init(List<String> files) async {
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll(files);
  }

  void startBgm(String fileName) {
    FlameAudio.bgm.play(fileName, volume: 0.4);
  }

  void pauseBgm() {
    FlameAudio.bgm.pause();
  }

  void resumeBgm() {
    FlameAudio.bgm.resume();
  }

  void stopBgm() {
    FlameAudio.bgm.stop();
  }

  void playSfx(String fileName) {
    FlameAudio.audioCache.play(fileName);
  }
}
