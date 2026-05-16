import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/quiz_engine.dart';
import '../../core/progress_tracker.dart';
import '../../core/settings_service.dart';

enum QuizState { asking, correct, wrong }

class QuizNotifier extends StateNotifier<QuizViewModel> {
  final QuizEngine _engine;
  final ProgressTracker _tracker;
  final SettingsService _settings;
  int _answeredCorrectly = 0;

  QuizNotifier(this._engine, this._tracker, this._settings)
      : super(QuizViewModel(
          question: QuizEngine().next(),
          state: QuizState.asking,
          correctCount: 0,
          needed: 1,
        )) {
    _nextQuestion();
  }

  void answer(int choiceIndex) {
    if (state.state != QuizState.asking) return;
    final correct = choiceIndex == state.question.correctIndex;
    _engine.recordResult(state.question, correct);
    _tracker.record(state.question.a, state.question.b, correct);

    if (correct) {
      _answeredCorrectly++;
      state = state.copyWith(
        state: QuizState.correct,
        correctCount: _answeredCorrectly,
      );
    } else {
      state = state.copyWith(state: QuizState.wrong);
    }
  }

  void next() {
    _nextQuestion();
  }

  void _nextQuestion() {
    state = state.copyWith(
      question: _engine.next(
        minTable: _settings.minTable,
        maxTable: _settings.maxTable,
      ),
      state: QuizState.asking,
      needed: _settings.questionsPerUnlock,
    );
  }

  bool get isComplete =>
      _answeredCorrectly >= _settings.questionsPerUnlock;
}

class QuizViewModel {
  final QuizQuestion question;
  final QuizState state;
  final int correctCount;
  final int needed;

  const QuizViewModel({
    required this.question,
    required this.state,
    required this.correctCount,
    required this.needed,
  });

  QuizViewModel copyWith({
    QuizQuestion? question,
    QuizState? state,
    int? correctCount,
    int? needed,
  }) =>
      QuizViewModel(
        question: question ?? this.question,
        state: state ?? this.state,
        correctCount: correctCount ?? this.correctCount,
        needed: needed ?? this.needed,
      );
}

// Providers
final progressTrackerProvider = Provider((ref) => ProgressTracker());
final settingsServiceProvider = Provider((ref) => SettingsService());
final quizEngineProvider = Provider((ref) => QuizEngine());

final quizControllerProvider =
    StateNotifierProvider<QuizNotifier, QuizViewModel>((ref) {
  return QuizNotifier(
    ref.read(quizEngineProvider),
    ref.read(progressTrackerProvider),
    ref.read(settingsServiceProvider),
  );
});
