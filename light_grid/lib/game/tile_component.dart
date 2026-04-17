import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'light_grid_game.dart';

class TileComponent extends PositionComponent with TapCallbacks, HasGameRef<LightGridGame> {
  final Point<int> gridPosition;
  bool isOn;
  
  late RectangleComponent _background;
  // late RectangleComponent _glow;

  static const double tileSize = 60.0;
  static const double margin = 4.0;

  TileComponent({
    required this.gridPosition,
    required this.isOn,
  });

  @override
  Future<void> onLoad() async {
    size = Vector2.all(tileSize);
    anchor = Anchor.center;

    // Background tile
    _background = RectangleComponent(
      size: Vector2.all(tileSize - margin * 2),
      position: Vector2.all(margin),
      paint: Paint()
        ..color = isOn ? Colors.cyanAccent : Colors.grey.withOpacity(0.2)
        ..style = PaintingStyle.fill,
    );
    _background.renderShape = true;
    _background.nativeAngle = 0;
    
    // Add rounded corners via a ClipComponent if needed, but let's use Simple Rounded Rect
    // Actually, flame's RectangleComponent is sharp. I'll use a Custom Painter or just a very nice look.
    add(_background);

    // Initial state
    _updateAppearance(animate: false);
  }

  void updateState(bool newState) {
    if (isOn == newState) return;
    isOn = newState;
    _updateAppearance(animate: true);
  }

  void _updateAppearance({bool animate = true}) {
    final targetColor = isOn ? Colors.cyanAccent : Colors.blueGrey.shade900;
    
    if (animate) {
      _background.add(
        ColorEffect(
          targetColor,
          EffectController(duration: 0.3, curve: Curves.easeOut),
        ),
      );
      
      // Tap ripple/scale effect
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
    } else {
      _background.paint.color = targetColor;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    gameRef.onTileTapped(gridPosition);
  }
}
