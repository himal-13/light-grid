import 'dart:math';
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

  // Daily Mode
  static String _getTodayKey() {
    return DateTime.now().toIso8601String().substring(0, 10);
  }

  static List<int> getDailyLevelIndices() {
    var box = Hive.box(progressBoxName);
    String today = _getTodayKey();
    List? saved = box.get('daily_levels_$today');
    
    if (saved != null) {
      return List<int>.from(saved);
    }

    // Generate new levels for today
    // Easy: 0-14, Medium: 15-34, Hard: 35-49
    final random = Random(DateTime.now().day + DateTime.now().month * 31);
    List<int> levels = [
      random.nextInt(15),
      15 + random.nextInt(20),
      35 + random.nextInt(15),
    ];
    
    box.put('daily_levels_$today', levels);
    return levels;
  }

  static bool isDailyLevelCompleted(int difficultyIndex) {
    var box = Hive.box(progressBoxName);
    String today = _getTodayKey();
    return box.get('daily_completed_${today}_$difficultyIndex', defaultValue: false);
  }

  // Memory Grid Mode
  static int getMemoryGridLevel() {
    var box = Hive.box(progressBoxName);
    return box.get('memoryGridLevel', defaultValue: 0);
  }

  static Future<void> saveMemoryGridLevel(int level) async {
    var box = Hive.box(progressBoxName);
    await box.put('memoryGridLevel', level);
  }
}
