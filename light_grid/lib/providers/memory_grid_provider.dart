import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../services/hive_service.dart';
import '../services/audio_service.dart';

enum MemoryGameState { showing, playing, success, failure }

class MemoryGridProvider extends ChangeNotifier {
  int _currentLevel = 0;
  int _gridSize = 3;
  List<Point<int>> _targetTiles = [];
  List<Point<int>> _userSelections = [];
  MemoryGameState _state = MemoryGameState.showing;
  
  int get currentLevel => _currentLevel;
  int get gridSize => _gridSize;
  List<Point<int>> get targetTiles => _targetTiles;
  List<Point<int>> get userSelections => _userSelections;
  MemoryGameState get state => _state;

  MemoryGridProvider() {
    _currentLevel = HiveService.getMemoryGridLevel();
    _setupLevel();
  }

  void _setupLevel() {
    _state = MemoryGameState.showing;
    _userSelections.clear();
    
    // Grid size increases every 10 levels, starting at 3x3, max 7x7
    _gridSize = 3 + (_currentLevel ~/ 10);
    if (_gridSize > 7) _gridSize = 7;

    // Number of tiles to remember: level + 3, but limited
    int numTiles = 3 + (_currentLevel % 10) + (_currentLevel ~/ 10) * 2;
    // Cap numTiles to not exceed 60% of grid
    int maxPossible = (_gridSize * _gridSize * 0.6).floor();
    if (numTiles > maxPossible) numTiles = maxPossible;

    _targetTiles.clear();
    final random = Random();
    while (_targetTiles.length < numTiles) {
      final p = Point(random.nextInt(_gridSize), random.nextInt(_gridSize));
      if (!_targetTiles.contains(p)) {
        _targetTiles.add(p);
      }
    }

    notifyListeners();

    // After 2 seconds, transition to playing state
    Timer(const Duration(seconds: 2), () {
      _state = MemoryGameState.playing;
      notifyListeners();
    });
  }

  void onTileTap(Point<int> point) {
    if (_state != MemoryGameState.playing) return;
    if (_userSelections.contains(point)) return;

    if (_targetTiles.contains(point)) {
      _userSelections.add(point);
      AudioService.playToggle();
      
      if (_userSelections.length == _targetTiles.length) {
        _handleWin();
      }
    } else {
      _handleLoss();
    }
    
    notifyListeners();
  }

  void _handleWin() {
    _state = MemoryGameState.success;
    AudioService.playLevelComplete();
    
    _currentLevel++;
    HiveService.saveMemoryGridLevel(_currentLevel);
    
    Timer(const Duration(milliseconds: 1500), () {
      _setupLevel();
    });
  }

  void _handleLoss() {
    _state = MemoryGameState.failure;
    AudioService.playFail();
    
    Timer(const Duration(milliseconds: 1500), () {
      _setupLevel();
    });
  }

  void restartLevel() {
    _setupLevel();
  }
}
