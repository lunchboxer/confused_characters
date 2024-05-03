enum Difficulty { easy, medium, hard }

extension DifficultyExtension on Difficulty {
  String get name {
    switch (this) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.hard:
        return 'Hard';
    }
  }
}
