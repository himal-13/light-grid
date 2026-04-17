import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/level_model.dart';
import '../services/hive_service.dart';
import '../services/audio_service.dart';
import '../levels/level_data.dart';

enum GameTool { normal, brush, breakTool }

class GameProvider extends ChangeNotifier {
  int _currentLevelIndex = 0;
  Map<Point<int>, bool> _tileStates = {};
  int _moves = 0;
  bool _isLevelComplete = false;
  GameTool _selectedTool = GameTool.normal;
  
  // Undo history: stack of tile states
  final List<Map<Point<int>, bool>> _history = [];

  int get currentLevelIndex => _currentLevelIndex;
  int get moves => _moves;
  bool get isLevelComplete => _isLevelComplete;
  Map<Point<int>, bool> get tileStates => _tileStates;
  GameTool get selectedTool => _selectedTool;
  LevelData get currentLevel => allLevels[_currentLevelIndex];
  bool get canUndo => _history.isNotEmpty;

  void loadLevel(int index) {
    if (index < 0 || index >= allLevels.length) return;
    
    _currentLevelIndex = index;
    _moves = 0;
    _isLevelComplete = false;
    _tileStates = {};
    _selectedTool = GameTool.normal;
    _history.clear();
    
    LevelData level = allLevels[_currentLevelIndex];
    // Initialize all tiles from level definition
    for (var point in level.tiles) {
      _tileStates[point] = level.startingOnTiles.any((p) => p == point);
    }
    
    notifyListeners();
  }

  void setTool(GameTool tool) {
    _selectedTool = tool;
    notifyListeners();
  }

  void _saveState() {
    // Deep copy current state for history
    _history.add(Map.from(_tileStates));
  }

  void undo() {
    if (_history.isEmpty || _isLevelComplete) return;
    
    _tileStates = _history.removeLast();
    _moves--;
    if (_moves < 0) _moves = 0;
    
    notifyListeners();
  }

  void toggleTile(Point<int> point, {bool isManual = true}) {
    if (_isLevelComplete) return;

    if (isManual) _saveState();

    List<Point<int>> affectedPoints = [
      point, // Center
      Point(point.x - 1, point.y), // Left
      Point(point.x + 1, point.y), // Right
      Point(point.x, point.y - 1), // Up
      Point(point.x, point.y + 1), // Down
    ];

    for (var p in affectedPoints) {
      if (_tileStates.containsKey(p)) {
        _tileStates[p] = !(_tileStates[p] ?? false);
      }
    }

    if (isManual) {
      _moves++;
      AudioService.playToggle();
      _checkWin();
    }
    
    notifyListeners();
  }

  void brushTile(Point<int> point) {
    if (_isLevelComplete || !_tileStates.containsKey(point)) return;
    
    _saveState();
    _tileStates[point] = !(_tileStates[point] ?? false);
    _moves++;
    AudioService.playToggle();
    _checkWin();
    notifyListeners();
  }

  void breakTile(Point<int> point) {
    if (_isLevelComplete || !_tileStates.containsKey(point)) return;
    
    _saveState();
    _tileStates.remove(point);
    _moves++;
    AudioService.playToggle();
    _checkWin();
    notifyListeners();
  }

  void _checkWin() {
    if (_tileStates.isEmpty) return; // Cannot win an empty level

    // Check if all remaining tiles in the level are ON
    bool allOn = _tileStates.values.every((state) => state == true);
    
    if (allOn) {
      _isLevelComplete = true;
      AudioService.playLevelComplete();
      
      // Save progress
      var currentProgress = HiveService.getProgress(_currentLevelIndex);
      int newStars = _calculateStars(_moves, currentLevel.tiles.length);
      
      HiveService.saveProgress(ProgressData(
        levelId: _currentLevelIndex,
        isUnlocked: true,
        bestMoves: (currentProgress.bestMoves == 0 || _moves < currentProgress.bestMoves) ? _moves : currentProgress.bestMoves,
        stars: max(currentProgress.stars, newStars),
      ));
      
      // Unlock next level
      if (_currentLevelIndex + 1 < allLevels.length) {
        HiveService.unlockNextLevel(_currentLevelIndex);
      }
    }
  }

  int _calculateStars(int moves, int totalTiles) {
    // Simple heuristic: 3 stars if moves <= totalTiles / 2, 2 if moves <= totalTiles, 1 otherwise
    if (moves <= totalTiles / 2) return 3;
    if (moves <= totalTiles) return 2;
    return 1;
  }

  void resetLevel() {
    loadLevel(_currentLevelIndex);
  }
}
