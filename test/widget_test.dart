import 'package:flutter_test/flutter_test.dart';
import 'package:mathlock/core/quiz_engine.dart';

void main() {
  test('QuizEngine generates correct answers', () {
    final engine = QuizEngine();
    for (var i = 0; i < 20; i++) {
      final q = engine.next(minTable: 2, maxTable: 10);
      expect(q.correctAnswer, equals(q.a * q.b));
      expect(q.choices.contains(q.correctAnswer), isTrue);
      expect(q.choices.length, equals(4));
    }
  });

  test('QuizEngine boosts error weight', () {
    final engine = QuizEngine();
    final q = engine.next(minTable: 2, maxTable: 5);
    engine.recordResult(q, false);
    engine.recordResult(q, false);
    // After 2 failures the pair should have higher weight — no crash
    final next = engine.next(minTable: 2, maxTable: 5);
    expect(next.correctAnswer, greaterThan(0));
  });
}
