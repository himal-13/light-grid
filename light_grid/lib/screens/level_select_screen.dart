import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'game_screen.dart';
import '../services/hive_service.dart';
import '../levels/level_data.dart';
import '../models/level_model.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'SELECT LEVEL',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemCount: allLevels.length,
          itemBuilder: (context, index) {
            bool isUnlocked = HiveService.isLevelUnlocked(index);
            ProgressData progress = HiveService.getProgress(index);
            
            return _buildLevelButton(context, index, isUnlocked, progress);
          },
        ),
      ),
    );
  }

  Widget _buildLevelButton(BuildContext context, int index, bool isUnlocked, ProgressData progress) {
    return GestureDetector(
      onTap: isUnlocked 
        ? () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => GameScreen(levelIndex: index)),
          )
        : null,
      child: Opacity(
        opacity: isUnlocked ? 1.0 : 0.4,
        child: Container(
          decoration: BoxDecoration(
            color: isUnlocked ? Colors.blueGrey.shade900 : Colors.black,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isUnlocked ? Colors.cyanAccent : Colors.grey,
              width: 1.5,
            ),
            boxShadow: isUnlocked ? [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 1,
              )
            ] : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${index + 1}',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isUnlocked ? Colors.white : Colors.grey,
                ),
              ),
              if (isUnlocked && progress.stars > 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) => Icon(
                    Icons.star,
                    size: 10,
                    color: i < progress.stars ? Colors.yellowAccent : Colors.white24,
                  )),
                ),
              if (!isUnlocked)
                const Icon(Icons.lock, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
