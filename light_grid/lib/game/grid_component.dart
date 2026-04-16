import 'dart:math';
import 'package:flame/components.dart';
import 'tile_component.dart';
import '../models/level_model.dart';

class GridComponent extends PositionComponent {
  final LevelData level;
  final Map<Point<int>, bool> tileStates;
  final Map<Point<int>, TileComponent> _tileComponents = {};

  GridComponent({
    required this.level,
    required this.tileStates,
  });

  @override
  Future<void> onLoad() async {
    // Calculate bounds to center the grid
    int minX = level.tiles.map((e) => e.x).reduce(min);
    int maxX = level.tiles.map((e) => e.x).reduce(max);
    int minY = level.tiles.map((e) => e.y).reduce(min);
    int maxY = level.tiles.map((e) => e.y).reduce(max);

    double gridWidth = (maxX - minX + 1) * TileComponent.tileSize;
    double gridHeight = (maxY - minY + 1) * TileComponent.tileSize;
    
    size = Vector2(gridWidth, gridHeight);
    anchor = Anchor.center;

    for (var point in level.tiles) {
      final tile = TileComponent(
        gridPosition: point,
        isOn: tileStates[point] ?? false,
      );
      
      // Calculate local position based on coordinate
      tile.position = Vector2(
        (point.x - minX + 0.5) * TileComponent.tileSize,
        (point.y - minY + 0.5) * TileComponent.tileSize,
      );
      
      _tileComponents[point] = tile;
      add(tile);
    }
  }

  void updateTileStates(Map<Point<int>, bool> newStates) {
    newStates.forEach((point, isOn) {
      _tileComponents[point]?.updateState(isOn);
    });
  }
}
