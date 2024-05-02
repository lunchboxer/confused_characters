import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart'; // For reading files from assets
import 'package:confused_characters/difficulty.dart';

Future<String> replaceCharacters(
    String sentence, int level, Difficulty difficulty) async {
  String characterReplacementIndex =
      await rootBundle.loadString('assets/character-replacement-index.json');
  Map<String, dynamic> decodedMap = jsonDecode(characterReplacementIndex);

  Map<String, List<String>> characterReplacementMap = {};
  decodedMap.forEach((key, value) {
    characterReplacementMap[key] =
        (value as List).map((e) => e as String).toList();
  });

  List<int> indexes = List.generate(sentence.length, (index) => index)
    ..shuffle();
  List<int> charactersToReplace = indexes.sublist(
      0, min(_getNumCharactersToReplace(difficulty), sentence.length));

  String replacedSentence = sentence;
  for (int index in charactersToReplace) {
    String character = sentence[index];
    List<String>? similarCharacters = characterReplacementMap[character];

    // If character not found in characterReplacementMap, choose a random character to replace
    if (similarCharacters == null || similarCharacters.isEmpty) {
      List<String> allCharacters = characterReplacementMap.keys.toList();
      allCharacters.remove(character); // Remove the original character
      String randomCharacter =
          allCharacters[Random().nextInt(allCharacters.length)];
      replacedSentence =
          replacedSentence.replaceRange(index, index + 1, randomCharacter);
    } else {
      String replacementCharacter =
          similarCharacters[Random().nextInt(similarCharacters.length)];
      replacedSentence =
          replacedSentence.replaceRange(index, index + 1, replacementCharacter);
    }
  }

  return replacedSentence;
}

int _getNumCharactersToReplace(Difficulty difficulty) {
  switch (difficulty) {
    case Difficulty.easy:
      return 1;
    case Difficulty.medium:
      return 2;
    case Difficulty.hard:
      return 3;
    default:
      return 0;
  }
}
