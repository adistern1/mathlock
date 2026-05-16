import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CellProgress {
  final int correct;
  final int attempts;

  const CellProgress({required this.correct, required this.attempts});

  double get mastery => attempts == 0 ? 0 : correct / attempts;

  CellProgress withResult(bool isCorrect) => CellProgress(
        correct: correct + (isCorrect ? 1 : 0),
        attempts: attempts + 1,
      );

  Map<String, dynamic> toJson() => {'c': correct, 'a': attempts};
  factory CellProgress.fromJson(Map<String, dynamic> j) =>
      CellProgress(correct: j['c'] as int, attempts: j['a'] as int);
}

class ProgressTracker {
  static const _prefsKey = 'ml_progress';
  static const _streakKey = 'ml_streak';
  static const _lastDateKey = 'ml_last_date';
  static const _totalKey = 'ml_total';

  final Map<String, CellProgress> _cells = {};
  int _streak = 0;
  int _totalAnswered = 0;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      map.forEach((k, v) {
        _cells[k] = CellProgress.fromJson(v as Map<String, dynamic>);
      });
    }
    _streak = prefs.getInt(_streakKey) ?? 0;
    _totalAnswered = prefs.getInt(_totalKey) ?? 0;
    _updateStreak(prefs);
  }

  Future<void> record(int a, int b, bool correct) async {
    final key = '$a×$b';
    _cells[key] = (_cells[key] ?? const CellProgress(correct: 0, attempts: 0))
        .withResult(correct);
    _totalAnswered++;
    await _save();
  }

  CellProgress cellProgress(int a, int b) =>
      _cells['$a×$b'] ?? const CellProgress(correct: 0, attempts: 0);

  int get streak => _streak;
  int get totalAnswered => _totalAnswered;

  void _updateStreak(SharedPreferences prefs) {
    final last = prefs.getString(_lastDateKey);
    if (last == null) return;
    final lastDate = DateTime.parse(last);
    final diff = DateTime.now().difference(lastDate).inDays;
    if (diff > 1) _streak = 0;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final map = <String, dynamic>{};
    _cells.forEach((k, v) => map[k] = v.toJson());
    await prefs.setString(_prefsKey, jsonEncode(map));
    await prefs.setInt(_totalKey, _totalAnswered);
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final last = prefs.getString(_lastDateKey);
    if (last != today) {
      _streak++;
      await prefs.setInt(_streakKey, _streak);
      await prefs.setString(_lastDateKey, today);
    }
  }
}
