import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../services/hive_service.dart';
import '../services/audio_service.dart';

enum GridMathGameState { playing, success, failure }

class GridMathProvider extends ChangeNotifier {
  int _currentLevel = 0;
  int _gridRows = 3;
  int _gridCols = 3;
  int _currentNumber = 0;
  int _targetNumber = 0;
  int _movesLeft = 0;
  List<String> _operations = [];
  GridMathGameState _state = GridMathGameState.playing;

  int get currentLevel => _currentLevel;
  int get gridRows => _gridRows;
  int get gridCols => _gridCols;
  int get currentNumber => _currentNumber;
  int get targetNumber => _targetNumber;
  int get movesLeft => _movesLeft;
  List<String> get operations => _operations;
  GridMathGameState get state => _state;

  GridMathProvider() {
    _currentLevel = HiveService.getGridMathLevel();
    _setupLevel();
  }

  void _setupLevel() {
    _state = GridMathGameState.playing;

    // Grid size progression based on level
    final displayLevel = _currentLevel + 1;

    if (displayLevel <= 3) {
      _gridRows = 2;
      _gridCols = 3;
    } else if (displayLevel <= 6) {
      _gridRows = 3;
      _gridCols = 3;
    } else if (displayLevel <= 10) {
      _gridRows = 3;
      _gridCols = 4;
    } else {
      _gridRows = 4;
      _gridCols = 4;
    }

    // Generate operations
    _operations = _generateOperations(displayLevel);

    // Generate starting number and target
    _generateNumbers(displayLevel);

    // Set moves
    _movesLeft = _calculateMoves(displayLevel);

    notifyListeners();
  }

  List<String> _generateOperations(int level) {
    List<String> baseOps = ['+5', '-3', 'x2', '/2'];
    List<String> advancedOps = ['+10', '-7', 'x3', '/3', '+1', '-1'];

    List<String> availableOps = List.from(baseOps);
    if (level > 3) availableOps.addAll(advancedOps);

    List<String> ops = [];
    int numOps = _gridRows * _gridCols;
    final random = Random();

    for (int i = 0; i < numOps; i++) {
      ops.add(availableOps[random.nextInt(availableOps.length)]);
    }

    return ops;
  }

  void _generateNumbers(int level) {
    final random = Random();
    int start = 10 + level * 5;
    int target = start;

    // Apply random operations to get target
    int steps = 3 + level ~/ 2;
    for (int i = 0; i < steps; i++) {
      String op = _operations[random.nextInt(_operations.length)];
      target = _applyOperation(target, op);
      // Ensure target stays positive and reasonable
      if (target <= 0) target = 1;
      if (target > 1000) target = target ~/ 2;
    }

    _currentNumber = start;
    _targetNumber = target;
  }

  int _calculateMoves(int level) {
    return 5 + level;
  }

  int _applyOperation(int number, String op) {
    if (op.startsWith('+')) {
      return number + int.parse(op.substring(1));
    } else if (op.startsWith('-')) {
      return number - int.parse(op.substring(1));
    } else if (op.startsWith('x')) {
      return number * int.parse(op.substring(1));
    } else if (op.startsWith('/')) {
      int divisor = int.parse(op.substring(1));
      return number ~/ divisor; // Integer division
    }
    return number;
  }

  void onOperationTap(int index) {
    if (_state != GridMathGameState.playing || _movesLeft <= 0) return;

    String op = _operations[index];
    _currentNumber = _applyOperation(_currentNumber, op);
    _movesLeft--;

    AudioService.playToggle();

    if (_currentNumber == _targetNumber) {
      _handleWin();
    } else if (_movesLeft == 0) {
      _handleLoss();
    }

    notifyListeners();
  }

  void _handleWin() {
    _state = GridMathGameState.success;
    AudioService.playLevelComplete();

    _currentLevel++;
    HiveService.saveGridMathLevel(_currentLevel);

    Timer(const Duration(milliseconds: 1500), () {
      _setupLevel();
    });
  }

  void _handleLoss() {
    _state = GridMathGameState.failure;
    AudioService.playFail();

    Timer(const Duration(milliseconds: 1500), () {
      _setupLevel();
    });
  }

  void restartLevel() {
    _setupLevel();
  }
}