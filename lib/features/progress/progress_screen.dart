import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../quiz/quiz_controller.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracker = ref.read(progressTrackerProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.progress,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // Legend
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Legend(color: Colors.red.shade300, label: l10n.notLearned),
                    const SizedBox(width: 16),
                    _Legend(color: Colors.amber, label: l10n.learning),
                    const SizedBox(width: 16),
                    _Legend(color: Colors.green, label: l10n.mastered),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Grid
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _MultiplicationGrid(tracker: tracker),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 12,
            height: 12,
            decoration:
                BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

class _MultiplicationGrid extends StatelessWidget {
  final dynamic tracker;
  const _MultiplicationGrid({required this.tracker});

  Color _cellColor(double mastery) {
    if (mastery == 0) return Colors.red.shade300.withOpacity(0.6);
    if (mastery < 0.7) return Colors.amber.withOpacity(0.7);
    return Colors.green.withOpacity(0.8);
  }

  @override
  Widget build(BuildContext context) {
    const max = 10;
    return Table(
      defaultColumnWidth: const FlexColumnWidth(),
      children: [
        // Header row
        TableRow(
          children: [
            const SizedBox(height: 36),
            ...List.generate(max - 1, (i) => _HeaderCell('${i + 2}')),
          ],
        ),
        ...List.generate(max - 1, (rowIdx) {
          final a = rowIdx + 2;
          return TableRow(
            children: [
              _HeaderCell('$a'),
              ...List.generate(max - 1, (colIdx) {
                final b = colIdx + 2;
                final progress = tracker.cellProgress(a, b);
                return _Cell(
                  a: a,
                  b: b,
                  mastery: progress.mastery,
                  color: _cellColor(progress.mastery),
                );
              }),
            ],
          );
        }),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      alignment: Alignment.center,
      child: Text(text,
          style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold)),
    );
  }
}

class _Cell extends StatelessWidget {
  final int a;
  final int b;
  final double mastery;
  final Color color;
  const _Cell(
      {required this.a,
      required this.b,
      required this.mastery,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(
        '${a * b}',
        style: const TextStyle(
            color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
