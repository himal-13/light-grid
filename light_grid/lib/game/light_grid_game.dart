import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'grid_component.dart';
import '../providers/game_provider.dart';

class LightGridGame extends FlameGame {
  final GameProvider provider;
  GridComponent? _grid;

  LightGridGame(this.provider);

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    _loadCurrentLevel();
  }

  void _loadCurrentLevel() {
    if (_grid != null) {
      remove(_grid!);
    }

    _grid = GridComponent(
      level: provider.currentLevel,
      tileStates: provider.tileStates,
    );
    
    // Position grid in the center of the game view
    _grid!.position = size / 2;
    add(_grid!);
  }

  void onTileTapped(Point<int> point) {
    provider.toggleTile(point);
    // GridComponent will be updated via the refresh logic or direct call
    _grid?.updateTileStates(provider.tileStates);
  }

  // Called from UI when level changes or resets
  void refresh() {
    _loadCurrentLevel();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _grid?.position = size / 2;
  }
}
