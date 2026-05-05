import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'grid_math_game.dart';

class GridMathTileComponent extends PositionComponent with TapCallbacks, HasGameRef<GridMathGame> {
  final int index;
  final String operation;
  late RectangleComponent _background;
  late TextComponent _text;

  static const double tileSize = 80.0;
  static const double margin = 4.0;

  GridMathTileComponent({
    required this.index,
    required this.operation,
  });

  @override
  Future<void> onLoad() async {
    size = Vector2.all(tileSize);
    anchor = Anchor.center;

    _background = RectangleComponent(
      size: Vector2.all(tileSize - margin * 2),
      position: Vector2.all(margin),
      paint: Paint()
        ..color = Colors.blueGrey.shade800
        ..style = PaintingStyle.fill,
    );
    add(_background);

    _text = TextComponent(
      text: operation,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(tileSize / 2, tileSize / 2),
    );
    add(_text);
  }

  @override
  void onTapDown(TapDownEvent event) {
    gameRef.onTileTapped(index);

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