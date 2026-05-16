import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'l10n/app_localizations.dart';
import 'features/home/home_screen.dart';
import 'features/quiz/quiz_screen.dart';
import 'features/quiz/quiz_controller.dart';
import 'core/settings_service.dart';
import 'core/progress_tracker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settings = SettingsService();
  final tracker = ProgressTracker();
  await Future.wait([settings.load(), tracker.load()]);

  final isOverlayMode = await _isOverlayMode();

  runApp(
    ProviderScope(
      overrides: [
        settingsServiceProvider.overrideWithValue(settings),
        progressTrackerProvider.overrideWithValue(tracker),
      ],
      child: MathLockApp(isOverlayMode: isOverlayMode),
    ),
  );
}

Future<bool> _isOverlayMode() async {
  try {
    final result = await const MethodChannel('com.mathlock/overlay')
        .invokeMethod<bool>('isOverlayMode');
    return result ?? false;
  } on PlatformException {
    return false;
  }
}

class MathLockApp extends ConsumerWidget {
  final bool isOverlayMode;
  const MathLockApp({super.key, required this.isOverlayMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsServiceProvider);
    final locale = _localeFromCode(settings.locale);

    return MaterialApp(
      title: 'MathLock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6A11CB),
          brightness: Brightness.dark,
        ),
      ),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: isOverlayMode ? _OverlayQuizHost() : const HomeScreen(),
    );
  }

  Locale _localeFromCode(String code) {
    switch (code) {
      case 'he': return const Locale('he');
      case 'ar': return const Locale('ar');
      case 'es': return const Locale('es');
      case 'fr': return const Locale('fr');
      case 'de': return const Locale('de');
      default:   return const Locale('en');
    }
  }
}

class _OverlayQuizHost extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return QuizScreen(
      isOverlay: true,
      onUnlocked: () async {
        try {
          await const MethodChannel('com.mathlock/overlay')
              .invokeMethod('dismissOverlay');
        } on PlatformException catch (_) {}
        if (context.mounted) {
          await SystemNavigator.pop();
        }
      },
    );
  }
}
