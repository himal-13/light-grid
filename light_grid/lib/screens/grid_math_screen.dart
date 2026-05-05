import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/grid_math_provider.dart';
import '../game/grid_math_game.dart';

class GridMathScreen extends StatefulWidget {
  const GridMathScreen({super.key});

  @override
  State<GridMathScreen> createState() => _GridMathScreenState();
}

class _GridMathScreenState extends State<GridMathScreen> {
  late GridMathGame _game;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<GridMathProvider>(context, listen: false);
    _game = GridMathGame(provider);
    // Delay the level setup until after the first build to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.restartLevel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<GridMathProvider>(
        builder: (context, provider, child) {
          return SafeArea(
            child: Column(
              children: [
                _buildHeader(context, provider),
                _buildNumbers(provider),
                Expanded(
                  child: Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return GameWidget(game: _game);
                      },
                    ),
                  ),
                ),
                _buildStatus(provider),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, GridMathProvider provider) {
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
                'GRID MATH',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
              Text(
                'LEVEL ${provider.currentLevel + 1}',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildNumbers(GridMathProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNumberDisplay('CURRENT', provider.currentNumber, Colors.cyanAccent),
          const SizedBox(width: 40),
          Icon(Icons.arrow_forward, color: Colors.white70, size: 30),
          const SizedBox(width: 40),
          _buildNumberDisplay('TARGET', provider.targetNumber, Colors.greenAccent),
        ],
      ),
    );
  }

  Widget _buildNumberDisplay(String label, int number, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          number.toString(),
          style: GoogleFonts.outfit(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildStatus(GridMathProvider provider) {
    String text = '';
    Color color = Colors.white;

    switch (provider.state) {
      case GridMathGameState.playing:
        text = 'MOVES LEFT: ${provider.movesLeft}';
        color = Colors.cyanAccent;
        break;
      case GridMathGameState.success:
        text = 'PERFECT!';
        color = Colors.greenAccent;
        break;
      case GridMathGameState.failure:
        text = 'OUT OF MOVES';
        color = Colors.red.shade900;
        break;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        text,
        key: ValueKey(text),
        style: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 2,
        ),
      ),
    );
  }
}