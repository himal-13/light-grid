import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/level_model.dart';
import '../services/audio_service.dart';
import '../levels/path_fill_levels.dart';

class PathFillProvider extends ChangeNotifier {
  int _currentLevelIndex = 0;
  List<Point<int>> _currentPath = [];
  bool _isLevelComplete = false;

  int get currentLevelIndex => _currentLevelIndex;
  List<Point<int>> get currentPath => _currentPath;
  bool get isLevelComplete => _isLevelComplete;
  LevelData get currentLevel => pathFillLevels[_currentLevelIndex];

  void loadLevel(int index) {
    if (index < 0 || index >= pathFillLevels.length) return;
    _currentLevelIndex = index;
    _currentPath = [];
    _isLevelComplete = false;
    notifyListeners();
  }

  bool isTileInPath(Point<int> point) {
    return _currentPath.contains(point);
  }

  void tryAddTile(Point<int> point) {
    if (_isLevelComplete) return;
    if (!currentLevel.tiles.contains(point)) return;

    if (_currentPath.isEmpty) {
      _currentPath.add(point);
      AudioService.playPathTone(_currentPath.length - 1);
      notifyListeners();
      return;
    }

    // Check if point is already in path
    if (_currentPath.contains(point)) {
      // If it's the second to last point, we are backtracking
      if (_currentPath.length > 1 && _currentPath[_currentPath.length - 2] == point) {
        _currentPath.removeLast();
        notifyListeners();
      }
      return;
    }

    // Check adjacency to the last point
    Point<int> lastPoint = _currentPath.last;
    int dx = (lastPoint.x - point.x).abs();
    int dy = (lastPoint.y - point.y).abs();

    if ((dx == 1 && dy == 0) || (dx == 0 && dy == 1)) {
      _currentPath.add(point);
      AudioService.playPathTone(_currentPath.length - 1);
      _checkWin();
      notifyListeners();
    }
  }

  void resetPath() {
    if (_isLevelComplete) return;
    if (_currentPath.isNotEmpty) {
      _currentPath = [];
      notifyListeners();
    }
  }

  void _checkWin() {
    if (_currentPath.length == currentLevel.tiles.length) {
      _isLevelComplete = true;
      AudioService.playLevelComplete();
    }
  }

  void nextLevel() {
    if (_currentLevelIndex + 1 < pathFillLevels.length) {
      loadLevel(_currentLevelIndex + 1);
    }
  }
}
