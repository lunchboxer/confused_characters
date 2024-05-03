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
        leading: null,
        title: const Text('Setup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 32),
            const Text(
              "Welcome to Confused Characters!",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            const Text(
              "In this game of Chinese character puns, some characters are replaced with other characters. You have to guess what the correct characters are. Good luck!",
            ),
            const SizedBox(height: 24),
            const Text(
              'HSK vocabulary',
              style: TextStyle(fontSize: 24),
            ),
            ButtonGroup(
              selectedValue: selectedLevel,
              onSelected: (value) {
                setState(() {
                  selectedLevel = value;
                });
              },
              values: List.generate(6, (index) => index + 1),
            ),
            const SizedBox(height: 24),
            const Text(
              'Difficulty',
              style: TextStyle(fontSize: 24),
            ),
            ButtonGroup(
              selectedValue: selectedDifficulty.index,
              onSelected: (value) {
                setState(() {
                  selectedDifficulty = Difficulty.values[value];
                });
              },
              values: Difficulty.values.map((difficulty) => difficulty.index).toList(),
              labels: Difficulty.values.map((difficulty) => difficulty.name).toList(),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameScreen.withLevel(
                      level: selectedLevel,
                      difficulty: selectedDifficulty,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.videogame_asset),
              label: const Text('Play the game'),
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

class ButtonGroup extends StatelessWidget {
  final int selectedValue;
  final Function(int) onSelected;
  final List<int> values;
  final List<String>? labels;

  const ButtonGroup({
    super.key,
    required this.selectedValue,
    required this.onSelected,
    required this.values,
    this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: values.asMap().entries.map((entry) {
        final value = entry.value;
        final label = labels?.elementAt(entry.key) ?? value.toString();
        return OutlinedButton(
          onPressed: () => onSelected(value),
          style: OutlinedButton.styleFrom(
            backgroundColor: value == selectedValue ? Theme.of(context).colorScheme.primary : null,
            foregroundColor: value == selectedValue ? Theme.of(context).colorScheme.onPrimary : null,
          ),
          child: Text(label),
        );
      }).toList(),
    );
  }
}
