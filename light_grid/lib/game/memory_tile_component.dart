import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'memory_grid_game.dart';

class MemoryTileComponent extends PositionComponent with TapCallbacks, HasGameRef<MemoryGridGame> {
  final Point<int> gridPosition;
  late RectangleComponent _background;
  bool _isInitialized = false;
  
  static const double tileSize = 60.0;
  static const double margin = 4.0;

  MemoryTileComponent({
    required this.gridPosition,
  });

  @override
  Future<void> onLoad() async {
    size = Vector2.all(tileSize);
    anchor = Anchor.center;

    _background = RectangleComponent(
      size: Vector2.all(tileSize - margin * 2),
      position: Vector2.all(margin),
      paint: Paint()
        ..color = Colors.blueGrey.shade900
        ..style = PaintingStyle.fill,
    );
    add(_background);
    _isInitialized = true;
  }

  void updateAppearance({
    required bool isTarget,
    required bool isSelected,
    required bool isShowingPhase,
    required bool isFailed,
  }) {
    if (!_isInitialized) return;

    Color targetColor = Colors.blueGrey.shade900;
 
    if (isShowingPhase) {
      if (isTarget) {
        targetColor = Colors.redAccent;
      }
    } else {
      if (isSelected) {
        targetColor = Colors.redAccent;
      } else if (isFailed && isTarget) {
        targetColor = Colors.red.shade900;
      }
    }
 
    _background.paint.color = targetColor;
  }

  @override
  void onTapDown(TapDownEvent event) {
    gameRef.onTileTapped(gridPosition);
    
    // Feedback animation
    add(
      ScaleEffect.to(
        Vector2.all(1.1),
        EffectController(
          duration: 0.1,
          reverseDuration: 0.1,
          curve: Curves.easeInOut,
        ),
      ),
    );
  }
}
