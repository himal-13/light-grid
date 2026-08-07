import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../providers/path_fill_provider.dart';
import 'path_tile_component.dart';

class PathFillGame extends FlameGame with DragCallbacks {
  final PathFillProvider provider;
  final Map<Point<int>, PathTileComponent> _tiles = {};
  late PositionComponent _gridContainer;

  PathFillGame(this.provider);

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    _loadLevel();
  }

  void _loadLevel() {
    _tiles.clear();
    removeAll(children);

    _gridContainer = PositionComponent();
    add(_gridContainer);

    final level = provider.currentLevel;

    // Calculate bounds
    int minX = level.tiles.map((e) => e.x).reduce(min);
    int maxX = level.tiles.map((e) => e.x).reduce(max);
    int minY = level.tiles.map((e) => e.y).reduce(min);
    int maxY = level.tiles.map((e) => e.y).reduce(max);

    double gridWidth = (maxX - minX + 1) * PathTileComponent.tileSize;
    double gridHeight = (maxY - minY + 1) * PathTileComponent.tileSize;

    _gridContainer.size = Vector2(gridWidth, gridHeight);
    _gridContainer.anchor = Anchor.center;
    _gridContainer.position = size / 2;

    for (var point in level.tiles) {
      final tile = PathTileComponent(
        gridPosition: point,
        isInPath: provider.isTileInPath(point),
      );

      tile.position = Vector2(
        (point.x - minX + 0.5) * PathTileComponent.tileSize,
        (point.y - minY + 0.5) * PathTileComponent.tileSize,
      );

      _tiles[point] = tile;
      _gridContainer.add(tile);
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (provider.isLevelComplete) return;

    // Convert screen position to local position in grid container
    final localPos = _gridContainer.toLocal(event.localEndPosition);

    // Find which tile is at this position
    final level = provider.currentLevel;
    int minX = level.tiles.map((e) => e.x).reduce(min);
    int minY = level.tiles.map((e) => e.y).reduce(min);

    int gx = (localPos.x / PathTileComponent.tileSize).floor() + minX;
    int gy = (localPos.y / PathTileComponent.tileSize).floor() + minY;

    final point = Point(gx, gy);
    if (level.tiles.contains(point)) {
      provider.tryAddTile(point);
      _updateVisuals();
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (!provider.isLevelComplete) {
      provider.resetPath();
      _updateVisuals();
    }
  }

  void _updateVisuals() {
    _tiles.forEach((point, component) {
      component.updatePathState(provider.isTileInPath(point));
    });
  }

  void refresh() {
    _loadLevel();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (this.isLoaded) {
      _gridContainer.position = size / 2;
    }
  }
}
