import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../services/hive_service.dart';
import '../services/audio_service.dart';

enum MemoryGameState { showing, playing, success, failure }

class MemoryGridProvider extends ChangeNotifier {
  int _currentLevel = 0;
  int _gridRows = 3;
  int _gridCols = 3;
  List<Point<int>> _targetTiles = [];
  List<Point<int>> _userSelections = [];
  MemoryGameState _state = MemoryGameState.showing;
  
  int get currentLevel => _currentLevel;
  int get gridRows => _gridRows;
  int get gridCols => _gridCols;
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
    
    // Grid size progression based on level
    // Level 1 (index 0): 2x2
    // Level 2 (index 1): 3x3
    // Level 3 (index 2): 3x4
    // Level 4 (index 3): 4x4
    // Level 5 (index 4): 4x5
    // Level 6 (index 5): 4x5
    // Level 7+ (index 6+): 5x5
    
    final displayLevel = _currentLevel + 1;
    
    if (displayLevel == 1) {
      _gridRows = 2;
      _gridCols = 2;
    } else if (displayLevel == 2) {
      _gridRows = 3;
      _gridCols = 3;
    } else if (displayLevel == 3) {
      _gridRows = 3;
      _gridCols = 4;
    } else if (displayLevel == 4) {
      _gridRows = 4;
      _gridCols = 4;
    } else if (displayLevel == 5 || displayLevel == 6) {
      _gridRows = 4;
      _gridCols = 5;
    } else {
      _gridRows = 5;
      _gridCols = 5;
    }

    // Number of tiles to remember: level + 2, but max 10
    int numTiles = displayLevel + 2;
    if (numTiles > 10) numTiles = 10;

    _targetTiles.clear();
    final random = Random();
    while (_targetTiles.length < numTiles) {
      final p = Point(random.nextInt(_gridCols), random.nextInt(_gridRows));
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
