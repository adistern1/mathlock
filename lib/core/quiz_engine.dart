import 'dart:math';

class QuizQuestion {
  final int a;
  final int b;
  final List<int> choices;
  final int correctIndex;

  const QuizQuestion({
    required this.a,
    required this.b,
    required this.choices,
    required this.correctIndex,
  });

  int get correctAnswer => a * b;
}

class QuizEngine {
  final _rng = Random();

  // Weighted table: pairs that were wrong recently get higher weight
  final Map<String, int> _errorWeights = {};

  /// Returns a random question from the configured table range.
  QuizQuestion next({int minTable = 2, int maxTable = 10}) {
    final pair = _pickPair(minTable, maxTable);
    final a = pair.$1;
    final b = pair.$2;
    final correct = a * b;
    final choices = _generateChoices(correct, minTable, maxTable);
    final correctIndex = choices.indexOf(correct);
    return QuizQuestion(a: a, b: b, choices: choices, correctIndex: correctIndex);
  }

  (int, int) _pickPair(int min, int max) {
    // Build weighted pool
    final pool = <(int, int)>[];
    for (var a = min; a <= max; a++) {
      for (var b = 2; b <= max; b++) {
        final weight = 1 + (_errorWeights['$a×$b'] ?? 0);
        for (var w = 0; w < weight; w++) {
          pool.add((a, b));
        }
      }
    }
    return pool[_rng.nextInt(pool.length)];
  }

  List<int> _generateChoices(int correct, int min, int max) {
    final set = <int>{correct};
    while (set.length < 4) {
      final a = min + _rng.nextInt(max - min + 1);
      final b = 2 + _rng.nextInt(max - 1);
      final candidate = a * b;
      if (candidate != correct && candidate > 0) set.add(candidate);
    }
    final list = set.toList()..shuffle(_rng);
    return list;
  }

  void recordResult(QuizQuestion q, bool correct) {
    final key = '${q.a}×${q.b}';
    if (correct) {
      _errorWeights[key] = max(0, (_errorWeights[key] ?? 0) - 1);
    } else {
      _errorWeights[key] = (_errorWeights[key] ?? 0) + 3;
    }
  }
}
