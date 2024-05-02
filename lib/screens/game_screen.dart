import 'package:flutter/material.dart';
import 'package:confused_characters/difficulty.dart';
import 'package:confused_characters/utils.dart';
import 'package:confused_characters/character_replacement.dart';

class GameScreen extends StatefulWidget {
  final int level;
  final Difficulty difficulty;

  const GameScreen({super.key, required this.level, required this.difficulty});

  const GameScreen.withLevel(
      {super.key, required this.level, required this.difficulty});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  int _score = 0;
  String _currentSentence = '';
  List<int> _replacedCharIndices = [];
  int _currentCharIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadNextSentence();
  }

  Future<void> _loadNextSentence() async {
    final sentencesForLevel = await readSentencesFromJSON();
    final originalSentence =
        (sentencesForLevel['${widget.level}']!..shuffle()).first;
    _currentSentence = await replaceCharacters(
        originalSentence, widget.level, widget.difficulty);
    _replacedCharIndices =
        _getReplacedCharIndices(_currentSentence, originalSentence);
    setState(() {});
  }

  List<int> _getReplacedCharIndices(String replaced, String original) {
    final replacedChars = replaced.split('');
    final originalChars = original.split('');
    final indices = <int>[];
    for (int i = 0; i < replacedChars.length; i++) {
      if (replacedChars[i] != originalChars[i]) {
        indices.add(i);
      }
    }
    return indices;
  }

  void _handleCharacterTap(int index) {
    setState(() {
      _currentCharIndex = index;
    });
  }

  void _handleCharacterSelection(String selectedChar) {
    final originalChar =
        _currentSentence[_replacedCharIndices[_currentCharIndex]];
    if (selectedChar == originalChar) {
      setState(() {
        _score++;
      });
    }
    _loadNextSentence();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confused Characters'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ReplacedCharacterText(
              sentence: _currentSentence,
              replacedCharIndices: _replacedCharIndices,
              onCharacterTap: _handleCharacterTap,
            ),
          ),
          const SizedBox(height: 16),
          Text('Score: $_score'),
          if (_currentCharIndex != -1)
            CharacterOptions(
              originalChar:
                  _currentSentence[_replacedCharIndices[_currentCharIndex]],
              onCharacterSelected: _handleCharacterSelection,
            ),
        ],
      ),
    );
  }
}

class ReplacedCharacterText extends StatelessWidget {
  final String sentence;
  final List<int> replacedCharIndices;
  final Function(int) onCharacterTap;

  const ReplacedCharacterText({
    super.key,
    required this.sentence,
    required this.replacedCharIndices,
    required this.onCharacterTap,
  });

  @override
  Widget build(BuildContext context) {
    final spans = <InlineSpan>[];
    final chars = sentence.split('');
    int index = 0;
    for (final char in chars) {
      final isReplaced = replacedCharIndices.contains(index);
      spans.add(
        WidgetSpan(
          child: GestureDetector(
            onTap: isReplaced ? () => onCharacterTap(index) : null,
            child: Text(
              char,
              style: TextStyle(
                color: isReplaced
                    ? Colors.red
                    : Theme.of(context).colorScheme.onSurface,
                fontSize: 32,
              ),
            ),
          ),
        ),
      );
      index++;
    }
    return Text.rich(TextSpan(children: spans));
  }
}

class CharacterOptions extends StatelessWidget {
  final String originalChar;
  final Function(String) onCharacterSelected;

  const CharacterOptions({
    super.key,
    required this.originalChar,
    required this.onCharacterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<String>>>(
      future: readReplacementIndex(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final replacementIndex = snapshot.data!;
          final similarChars = replacementIndex[originalChar] ?? [];
          final options = [
            originalChar,
            ...similarChars.take(3).toList()..shuffle()
          ];
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((char) {
              return InkWell(
                onTap: () => onCharacterSelected(char),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    char,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              );
            }).toList(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
