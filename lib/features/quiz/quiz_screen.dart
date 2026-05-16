import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../core/settings_service.dart';
import '../../core/progress_tracker.dart';
import 'quiz_controller.dart';

const _channel = MethodChannel('com.mathlock/overlay');

class QuizScreen extends ConsumerStatefulWidget {
  final bool isOverlay;
  final VoidCallback? onUnlocked;

  const QuizScreen({super.key, this.isOverlay = false, this.onUnlocked});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confetti;
  late AnimationController _shakeCtrl;
  int _parentTaps = 0;
  late Animation<double> _shakeAnim;
  late AnimationController _scaleCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 2));

    _shakeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _shakeAnim = Tween(begin: 0.0, end: 12.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeCtrl);

    _scaleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _scaleAnim = Tween(begin: 1.0, end: 1.15)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(_scaleCtrl);
  }

  @override
  void dispose() {
    _confetti.dispose();
    _shakeCtrl.dispose();
    _scaleCtrl.dispose();
    super.dispose();
  }

  void _onAnswer(int index) {
    final notifier = ref.read(quizControllerProvider.notifier);
    notifier.answer(index);

    final vm = ref.read(quizControllerProvider);
    if (vm.state == QuizState.correct) {
      _confetti.play();
      _scaleCtrl.forward().then((_) => _scaleCtrl.reverse());
      if (notifier.isComplete) {
        Future.delayed(const Duration(milliseconds: 1800), () {
          widget.onUnlocked?.call();
        });
      } else {
        Future.delayed(const Duration(milliseconds: 1200), () {
          notifier.next();
        });
      }
    } else {
      _shakeCtrl.forward().then((_) => _shakeCtrl.reset());
      Future.delayed(const Duration(milliseconds: 800), () {
        notifier.next();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(quizControllerProvider);
    final l10n = AppLocalizations.of(context)!;
    final hour = DateTime.now().hour;
    final gradientColors = hour < 12
        ? [const Color(0xFF6A11CB), const Color(0xFF2575FC)]
        : hour < 18
            ? [const Color(0xFFf7971e), const Color(0xFFffd200)]
            : [const Color(0xFF1a1a2e), const Color(0xFF16213e)];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              ConfettiWidget(
                confettiController: _confetti,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 30,
                gravity: 0.3,
                colors: const [
                  Colors.red, Colors.yellow, Colors.green,
                  Colors.blue, Colors.pink,
                ],
              ),
              _body(context, vm, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext ctx, QuizViewModel vm, AppLocalizations l10n) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Header
        Column(
          children: [
            Text(
              '🔐 MathLock',
              style: Theme.of(ctx)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.solveToUnlock,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
            if (vm.needed > 1) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  vm.needed,
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Icon(
                      i < vm.correctCount ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),

        // Question card
        AnimatedBuilder(
          animation: Listenable.merge([_shakeAnim, _scaleAnim]),
          builder: (_, child) => Transform.translate(
            offset: Offset(
              vm.state == QuizState.wrong
                  ? _shakeAnim.value * (DateTime.now().millisecond % 2 == 0 ? 1 : -1)
                  : 0,
              0,
            ),
            child: Transform.scale(
              scale: vm.state == QuizState.correct ? _scaleAnim.value : 1.0,
              child: child,
            ),
          ),
          child: _QuestionCard(vm: vm),
        ),

        // Answer buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            childAspectRatio: 2.4,
            children: List.generate(
              vm.question.choices.length,
              (i) => _ChoiceButton(
                value: vm.question.choices[i],
                state: vm.state,
                isCorrect: i == vm.question.correctIndex,
                onTap: vm.state == QuizState.asking ? () => _onAnswer(i) : null,
              ),
            ),
          ),
        ),

        // Parent emergency exit: triple-tap bottom area
        GestureDetector(
          onTap: () {
            _parentTaps++;
            if (_parentTaps >= 3) {
              _parentTaps = 0;
              _showParentExit(context);
            }
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('· · ·',
                style: TextStyle(color: Colors.white24, fontSize: 18)),
          ),
        ),
      ],
    );
  }

  void _showParentExit(BuildContext ctx) {
    final pinCtrl = TextEditingController();
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: const Text('🔒 כניסת הורה',
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: pinCtrl,
          keyboardType: TextInputType.number,
          obscureText: true,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'קוד הורה',
            hintStyle: TextStyle(color: Colors.white38),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white38)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ביטול',
                style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () async {
              final settings = ref.read(settingsServiceProvider);
              if (settings.checkPin(pinCtrl.text)) {
                Navigator.pop(ctx);
                // Dismiss overlay and exit
                try {
                  await _channel.invokeMethod('dismissOverlay');
                } on PlatformException catch (_) {}
                widget.onUnlocked?.call();
              } else {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('קוד שגוי')));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: const Text('אשר', style: TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    ).whenComplete(() => pinCtrl.dispose());
  }
}

class _QuestionCard extends StatelessWidget {
  final QuizViewModel vm;
  const _QuestionCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white24, width: 1.5),
      ),
      child: Column(
        children: [
          // Emoji mascot
          Text(
            vm.state == QuizState.correct
                ? '🎉'
                : vm.state == QuizState.wrong
                    ? '😅'
                    : '🤔',
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 16),
          Text(
            '${vm.question.a}  ×  ${vm.question.b}  =  ?',
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  final int value;
  final QuizState state;
  final bool isCorrect;
  final VoidCallback? onTap;

  const _ChoiceButton({
    required this.value,
    required this.state,
    required this.isCorrect,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.white.withOpacity(0.2);
    Color border = Colors.white38;
    if (state != QuizState.asking) {
      if (isCorrect) {
        bg = Colors.green.withOpacity(0.7);
        border = Colors.greenAccent;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(
          '$value',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
