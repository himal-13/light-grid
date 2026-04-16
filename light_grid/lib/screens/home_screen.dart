import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'level_select_screen.dart';
import 'settings_screen.dart';
import 'game_screen.dart';
import '../services/hive_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.blueGrey.shade900],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LIGHT GRID',
              style: GoogleFonts.outfit(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
                letterSpacing: 4,
                shadows: [
                  Shadow(color: Colors.cyanAccent.withOpacity(0.5), blurRadius: 20),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Illuminate the Grid',
              style: GoogleFonts.outfit(
                fontSize: 18,
                color: Colors.white70,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 60),
            _buildMenuButton(
              context,
              'PLAY',
              () {
                // Find latest unlocked level
                int lastUnlocked = 0;
                for (int i = 0; i < 30; i++) {
                  if (HiveService.isLevelUnlocked(i)) lastUnlocked = i;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen(levelIndex: lastUnlocked)),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildMenuButton(
              context,
              'LEVELS',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LevelSelectScreen()),
              ),
            ),
            const SizedBox(height: 20),
            _buildMenuButton(
              context,
              'SETTINGS',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, VoidCallback onPressed) {
    return Container(
      width: 250,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3), width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
