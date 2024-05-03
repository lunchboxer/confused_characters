import 'package:flutter/material.dart';
import 'package:confused_characters/difficulty.dart';
import 'package:confused_characters/utils.dart';
import 'package:confused_characters/character_replacement.dart';
import 'package:confused_characters/screens/scoreboard_screen.dart';
import 'package:confused_characters/screens/setup_screen.dart';

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
  final int _rounds = 10;
  int _round = 0;
  String _currentSentence = '';
  List<int> _replacedCharIndices = [];
  List<int> _correctAnswerIndices = [];
  List<int> _wrongAnswerIndices = [];
  int _currentCharIndex = 0;
  bool _showCharacterOptions = false;
  String _originalSentence = '';

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
    setState(() {
      _currentCharIndex = 0;
      _originalSentence = originalSentence;
      _showCharacterOptions = false;
      _correctAnswerIndices = [];
      _wrongAnswerIndices = [];
      _round++;
    });
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
      _showCharacterOptions = true;
    });
  }

  void _handleCharacterSelected(String character) {
    setState(() {
      if (character == _originalSentence[_currentCharIndex]) {
        _score++;
        _currentSentence = _currentSentence.replaceRange(
          _currentCharIndex,
          _currentCharIndex + 1,
          character,
        );
        // remove the character from the list of replaced characters
        _replacedCharIndices.remove(_currentCharIndex);
        _correctAnswerIndices.add(_currentCharIndex);
      } else {
        _currentSentence = _currentSentence.replaceRange(
          _currentCharIndex,
          _currentCharIndex + 1,
          character,
        );
        // remove the character from the list of replaced characters
        _replacedCharIndices.remove(_currentCharIndex);
        _wrongAnswerIndices.add(_currentCharIndex);
      }
      _currentCharIndex = 0;
      _showCharacterOptions = false;
    });
  }

  void _handleSentenceDone() {
    if (_round == _rounds) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ScoreboardScreen(
            difficulty: widget.difficulty,
            level: widget.level,
            score: _score,
          ),
        ),
      );
    } else {
      _loadNextSentence();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confused Characters'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            'Round $_round/$_rounds',
            style: const TextStyle(fontSize: 24),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ReplacedCharacterText(
                  sentence: _currentSentence,
                  replacedCharIndices: _replacedCharIndices,
                  correctAnswerIndices: _correctAnswerIndices,
                  wrongAnswerIndices: _wrongAnswerIndices,
                  onCharacterTap: _handleCharacterTap,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_showCharacterOptions) ...[
            const SizedBox(height: 16),
            CharacterOptions(
              originalChar: _originalSentence[_currentCharIndex],
              onCharacterSelected: _handleCharacterSelected,
            ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4.0), // Add padding around the buttons
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const SetupScreen()),
                      );
                    },
                    icon: const Icon(Icons.close),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                    ),
                    label: const Text('Quit'),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 4.0), // Add horizontal padding to each button
                  child: ElevatedButton.icon(
                    onPressed: _handleSentenceDone,
                    icon: const Icon(Icons.done),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                    ),
                    label: Text(_round == _rounds ? 'Done' : 'Next'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReplacedCharacterText extends StatelessWidget {
  final String sentence;
  final List<int> replacedCharIndices;
  final List<int> correctAnswerIndices;
  final List<int> wrongAnswerIndices;
  final Function(int) onCharacterTap;

  const ReplacedCharacterText({
    super.key,
    required this.sentence,
    required this.wrongAnswerIndices,
    required this.correctAnswerIndices,
    required this.replacedCharIndices,
    required this.onCharacterTap,
  });

  @override
  Widget build(BuildContext context) {
    final spans = <InlineSpan>[];
    final chars = sentence.split('');
    final characterIndices = <int>[];
    int charIndex = 0;

    for (int i = 0; i < chars.length; i++) {
      final isReplaced = replacedCharIndices.contains(i);
      final isCorrect = correctAnswerIndices.contains(i);
      final isWrong = wrongAnswerIndices.contains(i);
      characterIndices.add(charIndex);

      spans.add(
        WidgetSpan(
          child: GestureDetector(
            onTap: isReplaced
                ? () => onCharacterTap(i)
                : null, // Pass the original index here
            child: Text(
              chars[i],
              style: TextStyle(
                color: isReplaced
                    ? Theme.of(context).colorScheme.primary
                    : isCorrect
                        ? Colors.green
                        : isWrong
                            ? Colors.red
                            : Theme.of(context).colorScheme.onBackground,
                fontSize: 54,
              ),
            ),
          ),
        ),
      );

      charIndex += chars[i].length;
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
          final options = [originalChar, ...similarChars.take(3)]..shuffle();
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((char) {
              return InkWell(
                onTap: () => onCharacterSelected(char),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    char,
                    style: const TextStyle(fontSize: 54),
                  ),
                ),
              );
            }).toList(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return const Spacer();
      },
    );
  }
}
