import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../providers/grid_math_provider.dart';
import 'grid_math_tile_component.dart';

class GridMathGame extends FlameGame {
  final GridMathProvider provider;
  final Map<int, GridMathTileComponent> _tiles = {};
  PositionComponent? _gridContainer;

  GridMathGame(this.provider);

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

    final cols = provider.gridCols;
    final rows = provider.gridRows;

    final totalWidth = cols * GridMathTileComponent.tileSize;
    final totalHeight = rows * GridMathTileComponent.tileSize;

    _gridContainer!.size = Vector2(totalWidth, totalHeight);
    _gridContainer!.anchor = Anchor.center;
    _gridContainer!.position = size / 2;

    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        final index = y * cols + x;
        final tile = GridMathTileComponent(
          index: index,
          operation: provider.operations[index],
        );
        tile.position = Vector2(
          (x + 0.5) * GridMathTileComponent.tileSize,
          (y + 0.5) * GridMathTileComponent.tileSize,
        );
        _tiles[index] = tile;
        _gridContainer!.add(tile);
      }
    }

    add(_gridContainer!);
  }

  void onTileTapped(int index) {
    provider.onOperationTap(index);
    // No need to update tiles as they don't change appearance
  }

  void refresh() {
    _buildGrid();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Sync state if provider changed
    if (_tiles.length != provider.gridCols * provider.gridRows) {
      _buildGrid();
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _gridContainer?.position = size / 2;
  }
}