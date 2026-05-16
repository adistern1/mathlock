// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTagline => 'Antworte, um dein Handy zu entsperren';

  @override
  String get solveToUnlock => 'Löse, um zu entsperren 🔓';

  @override
  String get streak => 'Serie';

  @override
  String get days => 'Tage';

  @override
  String get totalAnswered => 'Beantwortet';

  @override
  String get practice => 'Üben';

  @override
  String get progress => 'Fortschritt';

  @override
  String get parentSettings => 'Elterneinstellungen';

  @override
  String get permissionNeeded => 'Berechtigung erforderlich';

  @override
  String get permissionExplain =>
      'MathLock benötigt die Berechtigung \'Über anderen Apps anzeigen\', um das Quiz beim Einschalten des Handys anzuzeigen.';

  @override
  String get grantPermission => 'Berechtigung erteilen';

  @override
  String get overlayActive =>
      'MathLock aktiv — Quiz erscheint beim Einschalten des Bildschirms';

  @override
  String get overlayInactive => 'MathLock inaktiv';

  @override
  String get notLearned => 'Nicht gelernt';

  @override
  String get learning => 'Lernend';

  @override
  String get mastered => 'Gelernt';

  @override
  String get parentArea => 'Elternbereich';

  @override
  String get enterPin => 'Eltern-PIN eingeben';

  @override
  String get wrongPin => 'Falscher PIN — erneut versuchen';

  @override
  String get unlock => 'Entsperren';

  @override
  String get back => 'Zurück';

  @override
  String get overlayEnabled => 'Quiz auf Sperrbildschirm';

  @override
  String get overlayExplain =>
      'Bei jedem Einschalten des Handys ein Quiz anzeigen';

  @override
  String get questionsPerUnlock => 'Fragen pro Entsperrung';

  @override
  String get tableRange => 'Multiplikationstabellen-Bereich';

  @override
  String get max => 'Max';

  @override
  String get changePin => 'Eltern-PIN ändern';

  @override
  String get newPin => 'Neuer PIN (4–6 Ziffern)';

  @override
  String get pinChanged => 'PIN erfolgreich geändert';

  @override
  String get save => 'Speichern';

  @override
  String get lockSettings => 'Einstellungen sperren';

  @override
  String get correct => 'Richtig!';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get wellDone => 'Super! Handy entsperrt 🎉';
}
