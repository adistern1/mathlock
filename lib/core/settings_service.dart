import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _overlayEnabledKey = 'ml_overlay';
  static const _minTableKey = 'ml_min';
  static const _maxTableKey = 'ml_max';
  static const _questionsPerUnlockKey = 'ml_qpu';
  static const _parentPinKey = 'ml_pin';
  static const _localeKey = 'ml_locale';

  bool _overlayEnabled = true;
  int _minTable = 2;
  int _maxTable = 10;
  int _questionsPerUnlock = 1;
  String _parentPin = '1234';
  String _locale = 'en';

  bool get overlayEnabled => _overlayEnabled;
  int get minTable => _minTable;
  int get maxTable => _maxTable;
  int get questionsPerUnlock => _questionsPerUnlock;
  String get parentPin => _parentPin;
  String get locale => _locale;

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    _overlayEnabled = p.getBool(_overlayEnabledKey) ?? true;
    _minTable = p.getInt(_minTableKey) ?? 2;
    _maxTable = p.getInt(_maxTableKey) ?? 10;
    _questionsPerUnlock = p.getInt(_questionsPerUnlockKey) ?? 1;
    _parentPin = p.getString(_parentPinKey) ?? '1234';
    _locale = p.getString(_localeKey) ?? 'en';
  }

  Future<void> setOverlayEnabled(bool v) async {
    _overlayEnabled = v;
    final p = await SharedPreferences.getInstance();
    await p.setBool(_overlayEnabledKey, v);
  }

  Future<void> setTableRange(int min, int max) async {
    _minTable = min;
    _maxTable = max;
    final p = await SharedPreferences.getInstance();
    await p.setInt(_minTableKey, min);
    await p.setInt(_maxTableKey, max);
  }

  Future<void> setQuestionsPerUnlock(int v) async {
    _questionsPerUnlock = v;
    final p = await SharedPreferences.getInstance();
    await p.setInt(_questionsPerUnlockKey, v);
  }

  Future<void> setParentPin(String pin) async {
    _parentPin = pin;
    final p = await SharedPreferences.getInstance();
    await p.setString(_parentPinKey, pin);
  }

  Future<void> setLocale(String locale) async {
    _locale = locale;
    final p = await SharedPreferences.getInstance();
    await p.setString(_localeKey, locale);
  }

  bool checkPin(String input) => input == _parentPin;
}
