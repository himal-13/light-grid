import 'package:flame_audio/flame_audio.dart';
import 'hive_service.dart';

class AudioService {
  static Future<void> init() async {
    await FlameAudio.audioCache.loadAll([
      'toggle.wav',
      'success.wav',
      'fail.wav',
      'level-complete.wav',
      'brush.wav',
      'break.wav',
    ]);
  }

  static void playTap() {
    if (HiveService.getSoundEnabled()) {
      FlameAudio.play('toggle.wav', volume: 0.5);
    }
  }

  static void playToggle() {
    if (HiveService.getSoundEnabled()) {
      FlameAudio.play('toggle.wav', volume: 0.3);
    }
  }

  static void playBrush() {
    if (HiveService.getSoundEnabled()) {
      FlameAudio.play('brush.wav', volume: 0.6);
    }
  }

  static void playBreak() {
    if (HiveService.getSoundEnabled()) {
      FlameAudio.play('break.wav', volume: 0.6);
    }
  }

  static void playSuccess() {
    if (HiveService.getSoundEnabled()) {
      FlameAudio.play('success.wav', volume: 0.8);
    }
  }

  static void playLevelComplete() {
    if (HiveService.getSoundEnabled()) {
      FlameAudio.play('level-complete.wav', volume: 0.8);
    }
  }

  static void playFail() {
    if (HiveService.getSoundEnabled()) {
      FlameAudio.play('fail.wav', volume: 0.6);
    }
  }
}
