import 'package:flutter/material.dart';
import 'package:confused_characters/difficulty.dart';
import 'package:confused_characters/screens/setup_screen.dart';
import 'package:confused_characters/screens/game_screen.dart';

class ScoreboardScreen extends StatelessWidget {
  final Difficulty difficulty;
  final int level;
  final int score;

  const ScoreboardScreen({
    super.key,
    required this.difficulty,
    required this.level,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Scoreboard'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Final Score',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(
                '$score',
                style: const TextStyle(
                  fontSize: 86,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text('Difficulty: ${difficulty.name}'),
              Text('Level: $level'),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SetupScreen()
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings),
                      label: const Text('Settings'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GameScreen(
                              level: level,
                              difficulty: difficulty,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.replay),
                      label: const Text('Play Again'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
