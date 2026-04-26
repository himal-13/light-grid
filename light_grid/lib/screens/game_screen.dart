import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/game_provider.dart';
import '../game/light_grid_game.dart';
import '../widgets/dialog_widgets.dart';

class GameScreen extends StatefulWidget {
  final int levelIndex;
  final bool isDailyMode;
  final int? dailyDifficultyIndex;

  const GameScreen({
    super.key, 
    required this.levelIndex, 
    this.isDailyMode = false, 
    this.dailyDifficultyIndex,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late LightGridGame _game;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<GameProvider>(context, listen: false);
    provider.loadLevel(widget.levelIndex);
    _game = LightGridGame(provider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<GameProvider>(
        builder: (context, provider, child) {
          // Check for win condition and show dialog
          if (provider.isLevelComplete && !_dialogShown && provider.currentLevelIndex == widget.levelIndex) {
            _dialogShown = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showWinDialog(
                context, 
                provider, 
                isDailyMode: widget.isDailyMode, 
                dailyDifficultyIndex: widget.dailyDifficultyIndex,
              );
            });
          } else if (!provider.isLevelComplete) {
            _dialogShown = false;
          }

          return SafeArea(
            child: Column(
              children: [
                _buildHeader(context, provider),
                _buildToolIndicator(provider),
                Expanded(
                  child: provider.tileStates.isEmpty 
                    ? const Center(child: CircularProgressIndicator()) 
                    : GameWidget(game: _game),
                ),
                _buildFooter(context, provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, GameProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Column(
            children: [
              Text(
                'LEVEL ${provider.currentLevelIndex + 1}',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              Text(
                'MOVES: ${provider.moves}',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(width: 48), // Spacer to balance the back button
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, GameProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            label: 'BRUSH',
            icon: Icons.brush,
            isActive: provider.selectedTool == GameTool.brush,
            onPressed: () => provider.setTool(
              provider.selectedTool == GameTool.brush ? GameTool.normal : GameTool.brush
            ),
          ),
          _buildActionButton(
            label: 'BREAK',
            icon: Icons.gavel,
            isActive: provider.selectedTool == GameTool.breakTool,
            onPressed: () => provider.setTool(
              provider.selectedTool == GameTool.breakTool ? GameTool.normal : GameTool.breakTool
            ),
          ),
          _buildActionButton(
            label: 'UNDO',
            icon: Icons.undo,
            isActive: false,
            onPressed: provider.canUndo ? () {
              provider.undo();
              _game.refresh();
            } : null,
          ),
          _buildActionButton(
            label: 'RESTART',
            icon: Icons.refresh,
            isActive: false,
            onPressed: () {
              provider.resetLevel();
              _game.refresh();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToolIndicator(GameProvider provider) {
    if (provider.selectedTool == GameTool.normal) return const SizedBox.shrink();

    final toolName = provider.selectedTool == GameTool.brush ? 'BRUSH' : 'BREAK';
    final toolIcon = provider.selectedTool == GameTool.brush ? Icons.brush : Icons.gavel;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.cyanAccent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(toolIcon, color: Colors.cyanAccent, size: 20),
          const SizedBox(width: 12),
          Text(
            '$toolName ACTIVE - TAP A TILE',
            style: GoogleFonts.outfit(
              color: Colors.cyanAccent,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => provider.setTool(GameTool.normal),
            child: const Icon(Icons.close, color: Colors.white54, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label, 
    required IconData icon, 
    required bool isActive,
    required VoidCallback? onPressed,
  }) {
    final color = isActive ? Colors.cyanAccent : (onPressed == null ? Colors.white24 : Colors.white70);
    
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? Colors.cyanAccent.withOpacity(0.1) : Colors.transparent,
              border: Border.all(color: isActive ? Colors.cyanAccent : Colors.white24, width: 2),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 10, 
              color: color,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
