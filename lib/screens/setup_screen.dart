import 'package:flutter/material.dart';
import 'package:confused_characters/screens/game_screen.dart';
import 'package:confused_characters/difficulty.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int selectedLevel = 4;
  Difficulty selectedDifficulty = Difficulty.medium;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Confused Characters'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            const Text(
              "Welcome to Confused Characters, the game of Chinese character puns. Let's get set up before we begin!",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            const Text(
              'HSK vocabulary',
              style: TextStyle(fontSize: 32),
            ),
            DropdownButton<int>(
              value: selectedLevel,
              style: const TextStyle(fontSize: 24),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedLevel = value;
                  });
                }
              },
              items: List.generate(6, (index) => index + 1)
                  .map((level) => DropdownMenuItem<int>(
                        value: level,
                        child: Text('Level $level'),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 32),
            const Text(
              'Difficulty',
              style: TextStyle(fontSize: 32),
            ),
            DropdownButton<Difficulty>(
              value: selectedDifficulty,
              style: const TextStyle(fontSize: 24),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedDifficulty = value;
                  });
                }
              },
              items: Difficulty.values
                  .map((difficulty) => DropdownMenuItem<Difficulty>(
                        value: difficulty,
                        child: Text(difficulty.name),
                      ))
                  .toList(),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GameScreen.withLevel(
                            level: selectedLevel,
                            difficulty: selectedDifficulty,
                          )),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
