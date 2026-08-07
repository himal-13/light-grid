import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class PathTileComponent extends PositionComponent {
  final Point<int> gridPosition;
  bool isInPath;
  
  late RectangleComponent _background;
  late RectangleComponent _inner;

  static const double tileSize = 60.0;
  static const double margin = 4.0;

  PathTileComponent({
    required this.gridPosition,
    this.isInPath = false,
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

    _inner = RectangleComponent(
      size: Vector2.all(0), // Start with 0 size
      position: Vector2.all(tileSize / 2),
      anchor: Anchor.center,
      paint: Paint()
        ..color = Colors.cyanAccent
        ..style = PaintingStyle.fill,
    );
    add(_inner);

    _updateAppearance(animate: false);
  }

  void updatePathState(bool newState) {
    if (isInPath == newState) return;
    isInPath = newState;
    _updateAppearance(animate: true);
  }

  void _updateAppearance({bool animate = true}) {
    if (isInPath) {
      if (animate) {
        _inner.add(
          SizeEffect.to(
            Vector2.all(tileSize - margin * 4),
            EffectController(duration: 0.2, curve: Curves.easeOutBack),
          ),
        );
        _inner.add(
          OpacityEffect.to(
            1.0,
            EffectController(duration: 0.2),
          ),
        );
      } else {
        _inner.size = Vector2.all(tileSize - margin * 4);
        _inner.opacity = 1.0;
      }
    } else {
      if (animate) {
        _inner.add(
          SizeEffect.to(
            Vector2.zero(),
            EffectController(duration: 0.2, curve: Curves.easeIn),
          ),
        );
      } else {
        _inner.size = Vector2.zero();
        _inner.opacity = 0.0;
      }
    }
  }
}
