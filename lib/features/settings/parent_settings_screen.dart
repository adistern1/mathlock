import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../quiz/quiz_controller.dart';

final _overlayChannel = const MethodChannel('com.mathlock/overlay');

class ParentSettingsScreen extends ConsumerStatefulWidget {
  const ParentSettingsScreen({super.key});

  @override
  ConsumerState<ParentSettingsScreen> createState() =>
      _ParentSettingsScreenState();
}

class _ParentSettingsScreenState
    extends ConsumerState<ParentSettingsScreen> {
  bool _unlocked = false;
  final _pinController = TextEditingController();
  bool _pinError = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _tryUnlock() {
    final settings = ref.read(settingsServiceProvider);
    if (settings.checkPin(_pinController.text)) {
      setState(() {
        _unlocked = true;
        _pinError = false;
      });
    } else {
      setState(() => _pinError = true);
      _pinController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: _unlocked
              ? _SettingsBody(onLock: () => setState(() => _unlocked = false))
              : _PinGate(
                  controller: _pinController,
                  hasError: _pinError,
                  onSubmit: _tryUnlock,
                ),
        ),
      ),
    );
  }
}

class _PinGate extends StatelessWidget {
  final TextEditingController controller;
  final bool hasError;
  final VoidCallback onSubmit;

  const _PinGate({
    required this.controller,
    required this.hasError,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('🔒', style: TextStyle(fontSize: 56)),
        const SizedBox(height: 16),
        Text(l10n.parentArea,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(l10n.enterPin,
            style: const TextStyle(color: Colors.white54, fontSize: 14)),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 8),
            decoration: InputDecoration(
              counterText: '',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                    color: hasError ? Colors.red : Colors.white38),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.white),
              ),
              errorText: hasError ? l10n.wrongPin : null,
            ),
            onSubmitted: (_) => onSubmit(),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(l10n.unlock),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.back,
              style: const TextStyle(color: Colors.white38)),
        ),
      ],
    );
  }
}

class _SettingsBody extends ConsumerStatefulWidget {
  final VoidCallback onLock;
  const _SettingsBody({required this.onLock});

  @override
  ConsumerState<_SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends ConsumerState<_SettingsBody> {
  late bool _overlayEnabled;
  late int _minTable;
  late int _maxTable;
  late int _questionsPerUnlock;
  final _newPinCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final s = ref.read(settingsServiceProvider);
    _overlayEnabled = s.overlayEnabled;
    _minTable = s.minTable;
    _maxTable = s.maxTable;
    _questionsPerUnlock = s.questionsPerUnlock;
  }

  @override
  void dispose() {
    _newPinCtrl.dispose();
    super.dispose();
  }

  Future<void> _toggleOverlay(bool val) async {
    setState(() => _overlayEnabled = val);
    final s = ref.read(settingsServiceProvider);
    await s.setOverlayEnabled(val);
    await _overlayChannel.invokeMethod('setOverlayEnabled', {'enabled': val});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final s = ref.read(settingsServiceProvider);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 8),
            Text(l10n.parentSettings,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 24),

        // Overlay toggle
        _SettingCard(
          child: Row(
            children: [
              const Text('🔐', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.overlayEnabled,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    Text(l10n.overlayExplain,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
              Switch(
                value: _overlayEnabled,
                onChanged: _toggleOverlay,
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Questions per unlock
        _SettingCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.questionsPerUnlock,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [1, 2, 3, 5].map((n) {
                  final selected = _questionsPerUnlock == n;
                  return GestureDetector(
                    onTap: () async {
                      setState(() => _questionsPerUnlock = n);
                      await s.setQuestionsPerUnlock(n);
                    },
                    child: Container(
                      width: 56,
                      height: 44,
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.white
                            : Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: selected ? Colors.white : Colors.white38),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$n',
                        style: TextStyle(
                            color: selected ? Colors.black87 : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Table range
        _SettingCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.tableRange,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              const SizedBox(height: 8),
              Text('${l10n.max}: $_maxTable',
                  style: const TextStyle(color: Colors.white70)),
              Slider(
                value: _maxTable.toDouble(),
                min: 5,
                max: 12,
                divisions: 7,
                label: '$_maxTable',
                activeColor: Colors.white,
                inactiveColor: Colors.white24,
                onChanged: (v) async {
                  setState(() => _maxTable = v.round());
                  await s.setTableRange(_minTable, v.round());
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Change PIN
        _SettingCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.changePin,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _newPinCtrl,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 6,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: l10n.newPin,
                        hintStyle: const TextStyle(color: Colors.white38),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white38)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      if (_newPinCtrl.text.length >= 4) {
                        await s.setParentPin(_newPinCtrl.text);
                        _newPinCtrl.clear();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.pinChanged)),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                    ),
                    child: Text(l10n.save),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        TextButton(
          onPressed: widget.onLock,
          child: Text(l10n.lockSettings,
              style: const TextStyle(color: Colors.white38)),
        ),

        const SizedBox(height: 8),

        // Uninstall button
        TextButton(
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: const Color(0xFF1a1a2e),
                title: const Text('הסר אפליקציה?',
                    style: TextStyle(color: Colors.white)),
                content: const Text(
                    'הפעולה תסיר את MathLock מהטלפון.',
                    style: TextStyle(color: Colors.white70)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('ביטול',
                        style: TextStyle(color: Colors.white54)),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red),
                    child: const Text('הסר'),
                  ),
                ],
              ),
            );
            if (confirmed == true) {
              await _overlayChannel.invokeMethod('uninstallApp');
            }
          },
          child: const Text('🗑️ הסר אפליקציה',
              style: TextStyle(color: Colors.red, fontSize: 13)),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}

class _SettingCard extends StatelessWidget {
  final Widget child;
  const _SettingCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: child,
    );
  }
}
