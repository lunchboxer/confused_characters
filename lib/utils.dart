import 'dart:convert';
import 'package:flutter/services.dart';

Future<Map<String, List<String>>> readSentencesFromJSON() async {
  final jsonString =
      await rootBundle.loadString('assets/grouped-sentences.json');
  final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
  final sentences = jsonData.map(
    (level, sentenceList) => MapEntry(
      level,
      List<String>.from(sentenceList.cast<String>()),
    ),
  );
  return sentences;
}

Future<Map<String, List<String>>> readReplacementIndex() async {
  final jsonString =
      await rootBundle.loadString('assets/character-replacement-index.json');
  final jsonData = jsonDecode(jsonString);

  final replacementIndex = <String, List<String>>{};

  jsonData.forEach((key, value) {
    replacementIndex[key] = List<String>.from(value.cast<String>());
  });

  return replacementIndex;
}
