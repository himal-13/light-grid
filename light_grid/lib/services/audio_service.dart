import 'package:flame_audio/flame_audio.dart';
import 'hive_service.dart';

class AudioService {
  static late AudioPool _togglePool;
  static late AudioPool _failPool;
  static late AudioPool _levelCompletePool;
  static late AudioPool _brushPool;
  static late AudioPool _breakPool;

  static Future<void> init() async {
    // Initialize AudioPools for low-latency playback
    _togglePool = await FlameAudio.createPool(
      'toggle.wav',
      minPlayers: 3,
      maxPlayers: 5,
    );
    _failPool = await FlameAudio.createPool(
      'fail.wav',
      minPlayers: 1,
      maxPlayers: 2,
    );
    _levelCompletePool = await FlameAudio.createPool(
      'level-complete.wav',
      minPlayers: 1,
      maxPlayers: 2,
    );
    _brushPool = await FlameAudio.createPool(
      'brush.wav',
      minPlayers: 3,
      maxPlayers: 5,
    );
    _breakPool = await FlameAudio.createPool(
      'break.wav',
      minPlayers: 3,
      maxPlayers: 5,
    );
  }

  static void playTap() {
    if (HiveService.getSoundEnabled()) {
      _togglePool.start(volume: 0.5);
    }
  }

  static void playToggle() {
    if (HiveService.getSoundEnabled()) {
      _togglePool.start(volume: 0.3);
    }
  }

  static void playBrush() {
    if (HiveService.getSoundEnabled()) {
      _brushPool.start(volume: 0.6);
    }
  }

  static void playBreak() {
    if (HiveService.getSoundEnabled()) {
      _breakPool.start(volume: 0.6);
    }
  }

  static void playLevelComplete() {
    if (HiveService.getSoundEnabled()) {
      _levelCompletePool.start(volume: 0.8);
    }
  }

  static void playFail() {
    if (HiveService.getSoundEnabled()) {
      _failPool.start(volume: 0.6);
    }
  }
}
