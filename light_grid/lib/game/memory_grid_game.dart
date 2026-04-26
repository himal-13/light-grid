import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../providers/memory_grid_provider.dart';
import 'memory_tile_component.dart';

class MemoryGridGame extends FlameGame {
  final MemoryGridProvider provider;
  final Map<Point<int>, MemoryTileComponent> _tiles = {};
  PositionComponent? _gridContainer;

  MemoryGridGame(this.provider);

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    _buildGrid();
  }

  void _buildGrid() {
    if (_gridContainer != null) {
      remove(_gridContainer!);
    }

    _gridContainer = PositionComponent();
    _tiles.clear();

    final size_ = provider.gridSize;
    final totalWidth = size_ * MemoryTileComponent.tileSize;
    _gridContainer!.size = Vector2.all(totalWidth);
    _gridContainer!.anchor = Anchor.center;
    _gridContainer!.position = size / 2;

    for (int y = 0; y < size_; y++) {
      for (int x = 0; x < size_; x++) {
        final point = Point(x, y);
        final tile = MemoryTileComponent(gridPosition: point);
        tile.position = Vector2(
          (x + 0.5) * MemoryTileComponent.tileSize,
          (y + 0.5) * MemoryTileComponent.tileSize,
        );
        _tiles[point] = tile;
        _gridContainer!.add(tile);
      }
    }

    add(_gridContainer!);
    _updateAllTiles();
  }

  void onTileTapped(Point<int> point) {
    provider.onTileTap(point);
    _updateAllTiles();
  }

  void _updateAllTiles() {
    _tiles.forEach((point, tile) {
      tile.updateAppearance(
        isTarget: provider.targetTiles.contains(point),
        isSelected: provider.userSelections.contains(point),
        isShowingPhase: provider.state == MemoryGameState.showing,
        isFailed: provider.state == MemoryGameState.failure,
      );
    });
  }

  void refresh() {
    _buildGrid();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Sync state if provider changed
    if (_tiles.length != provider.gridSize * provider.gridSize) {
      _buildGrid();
    } else {
      _updateAllTiles();
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _gridContainer?.position = size / 2;
  }
}
