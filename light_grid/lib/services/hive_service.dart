import 'package:hive_ce_flutter/hive_flutter.dart';
import '../models/level_model.dart';

class HiveService {
  static const String progressBoxName = 'progressBox';
  static const String settingsBoxName = 'settingsBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(progressBoxName);
    await Hive.openBox(settingsBoxName);
    
    // Unlock first level by default if box is empty
    var progressBox = Hive.box(progressBoxName);
    if (progressBox.isEmpty) {
      await saveProgress(ProgressData(levelId: 0, isUnlocked: true));
    }
  }

  static Future<void> saveProgress(ProgressData progress) async {
    var box = Hive.box(progressBoxName);
    await box.put(progress.levelId, progress.toJson());
  }

  static ProgressData getProgress(int levelId) {
    var box = Hive.box(progressBoxName);
    var data = box.get(levelId);
    if (data == null) {
      return ProgressData(levelId: levelId, isUnlocked: levelId == 0);
    }
    return ProgressData.fromJson(Map<dynamic, dynamic>.from(data));
  }

  static bool isLevelUnlocked(int levelId) {
    if (levelId == 0) return true;
    return getProgress(levelId).isUnlocked;
  }

  static Future<void> unlockNextLevel(int currentLevelId) async {
    var nextProgress = getProgress(currentLevelId + 1);
    if (!nextProgress.isUnlocked) {
      await saveProgress(ProgressData(
        levelId: currentLevelId + 1,
        isUnlocked: true,
        bestMoves: nextProgress.bestMoves,
        stars: nextProgress.stars,
      ));
    }
  }

  // Settings
  static bool getSoundEnabled() {
    var box = Hive.box(settingsBoxName);
    return box.get('soundEnabled', defaultValue: true);
  }

  static Future<void> setSoundEnabled(bool enabled) async {
    var box = Hive.box(settingsBoxName);
    await box.put('soundEnabled', enabled);
  }

  static bool getMusicEnabled() {
    var box = Hive.box(settingsBoxName);
    return box.get('musicEnabled', defaultValue: true);
  }

  static Future<void> setMusicEnabled(bool enabled) async {
    var box = Hive.box(settingsBoxName);
    await box.put('musicEnabled', enabled);
  }
}
