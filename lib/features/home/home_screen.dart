import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../quiz/quiz_controller.dart';
import '../settings/parent_settings_screen.dart';
import '../progress/progress_screen.dart';

final _overlayChannel = const MethodChannel('com.mathlock/overlay');

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _hasPermission = false;
  bool _isOverlayEnabled = true;

  @override
  void initState() {
    super.initState();
    _checkPermission();
    _startService();
  }

  Future<void> _checkPermission() async {
    try {
      final result = await _overlayChannel.invokeMethod<bool>('hasOverlayPermission');
      setState(() => _hasPermission = result ?? false);
    } on PlatformException {
      setState(() => _hasPermission = false);
    }
  }

  Future<void> _startService() async {
    try {
      await _overlayChannel.invokeMethod('startService');
    } on PlatformException catch (_) {}
  }

  Future<void> _requestPermission() async {
    await _overlayChannel.invokeMethod('requestOverlayPermission');
    await Future.delayed(const Duration(seconds: 1));
    await _checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tracker = ref.watch(progressTrackerProvider);

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
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 16),
              // Logo
              const Text(
                '🔐 MathLock',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.appTagline,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Permission card
              if (!_hasPermission) _PermissionCard(onGrant: _requestPermission),

              // Status card
              if (_hasPermission) _StatusCard(enabled: _isOverlayEnabled),

              const SizedBox(height: 16),

              // Stats row
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: '⭐',
                      label: l10n.streak,
                      value: '${tracker.streak} ${l10n.days}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: '✅',
                      label: l10n.totalAnswered,
                      value: '${tracker.totalAnswered}',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Practice button
              _GlassButton(
                icon: Icons.school,
                label: l10n.practice,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const _PracticeWrapper(),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Progress button
              _GlassButton(
                icon: Icons.bar_chart,
                label: l10n.progress,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProgressScreen()),
                ),
              ),

              const SizedBox(height: 12),

              // Settings button
              _GlassButton(
                icon: Icons.settings,
                label: l10n.parentSettings,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ParentSettingsScreen()),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  final VoidCallback onGrant;
  const _PermissionCard({required this.onGrant});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(l10n.permissionNeeded,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 4),
          Text(l10n.permissionExplain,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
              textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onGrant,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(l10n.grantPermission),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final bool enabled;
  const _StatusCard({required this.enabled});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white30),
      ),
      child: Row(
        children: [
          Text(enabled ? '🟢' : '🔴', style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              enabled ? l10n.overlayActive : l10n.overlayInactive,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  const _StatCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          Text(label,
              style: const TextStyle(color: Colors.white60, fontSize: 12)),
        ],
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _GlassButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(width: 16),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600)),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}

class _PracticeWrapper extends ConsumerWidget {
  const _PracticeWrapper();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ProviderScope(
        child: Consumer(builder: (ctx, ref, _) {
          return Navigator(
            onGenerateRoute: (_) => MaterialPageRoute(
              builder: (_) => _PracticeQuiz(
                onDone: () => Navigator.of(ctx).pop(),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _PracticeQuiz extends ConsumerStatefulWidget {
  final VoidCallback onDone;
  const _PracticeQuiz({required this.onDone});

  @override
  ConsumerState<_PracticeQuiz> createState() => _PracticeQuizState();
}

class _PracticeQuizState extends ConsumerState<_PracticeQuiz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: widget.onDone,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}
