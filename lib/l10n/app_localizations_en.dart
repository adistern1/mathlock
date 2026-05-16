// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTagline => 'Answer to unlock your phone';

  @override
  String get solveToUnlock => 'Solve to unlock 🔓';

  @override
  String get streak => 'Streak';

  @override
  String get days => 'days';

  @override
  String get totalAnswered => 'Answered';

  @override
  String get practice => 'Practice';

  @override
  String get progress => 'Progress';

  @override
  String get parentSettings => 'Parent Settings';

  @override
  String get permissionNeeded => 'Permission Needed';

  @override
  String get permissionExplain =>
      'MathLock needs the \'Display over other apps\' permission to show the quiz when your child turns on the phone.';

  @override
  String get grantPermission => 'Grant Permission';

  @override
  String get overlayActive =>
      'MathLock is active — quiz will appear on screen-on';

  @override
  String get overlayInactive => 'MathLock is inactive';

  @override
  String get notLearned => 'Not learned';

  @override
  String get learning => 'Learning';

  @override
  String get mastered => 'Mastered';

  @override
  String get parentArea => 'Parent Area';

  @override
  String get enterPin => 'Enter your parent PIN';

  @override
  String get wrongPin => 'Wrong PIN — try again';

  @override
  String get unlock => 'Unlock';

  @override
  String get back => 'Back';

  @override
  String get overlayEnabled => 'Lock Screen Quiz';

  @override
  String get overlayExplain => 'Show a quiz every time the phone turns on';

  @override
  String get questionsPerUnlock => 'Questions per unlock';

  @override
  String get tableRange => 'Multiplication table range';

  @override
  String get max => 'Max';

  @override
  String get changePin => 'Change Parent PIN';

  @override
  String get newPin => 'New PIN (4–6 digits)';

  @override
  String get pinChanged => 'PIN changed successfully';

  @override
  String get save => 'Save';

  @override
  String get lockSettings => 'Lock settings';

  @override
  String get correct => 'Correct!';

  @override
  String get tryAgain => 'Try again';

  @override
  String get wellDone => 'Well done! Phone unlocked 🎉';
}
