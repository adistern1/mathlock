// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTagline => 'ענה כדי לפתוח את הטלפון';

  @override
  String get solveToUnlock => 'פתור כדי לפתוח 🔓';

  @override
  String get streak => 'רצף';

  @override
  String get days => 'ימים';

  @override
  String get totalAnswered => 'ענית';

  @override
  String get practice => 'תרגול';

  @override
  String get progress => 'התקדמות';

  @override
  String get parentSettings => 'הגדרות הורה';

  @override
  String get permissionNeeded => 'נדרשת הרשאה';

  @override
  String get permissionExplain =>
      'MathLock צריכה הרשאת \'הצגה מעל אפליקציות אחרות\' כדי להציג את השאלה כשהטלפון מתעורר.';

  @override
  String get grantPermission => 'תן הרשאה';

  @override
  String get overlayActive => 'MathLock פעיל — שאלה תופיע בהדלקת המסך';

  @override
  String get overlayInactive => 'MathLock לא פעיל';

  @override
  String get notLearned => 'לא נלמד';

  @override
  String get learning => 'בלמידה';

  @override
  String get mastered => 'שולט';

  @override
  String get parentArea => 'אזור הורים';

  @override
  String get enterPin => 'הכנס את קוד ההורה';

  @override
  String get wrongPin => 'קוד שגוי — נסה שוב';

  @override
  String get unlock => 'פתח';

  @override
  String get back => 'חזרה';

  @override
  String get overlayEnabled => 'שאלה במסך הנעילה';

  @override
  String get overlayExplain => 'הצג שאלה בכל פעם שהטלפון מתעורר';

  @override
  String get questionsPerUnlock => 'שאלות לכל פתיחה';

  @override
  String get tableRange => 'טווח לוח הכפל';

  @override
  String get max => 'מקסימום';

  @override
  String get changePin => 'שנה קוד הורה';

  @override
  String get newPin => 'קוד חדש (4–6 ספרות)';

  @override
  String get pinChanged => 'הקוד שונה בהצלחה';

  @override
  String get save => 'שמור';

  @override
  String get lockSettings => 'נעל הגדרות';

  @override
  String get correct => 'נכון!';

  @override
  String get tryAgain => 'נסה שוב';

  @override
  String get wellDone => 'כל הכבוד! הטלפון פתוח 🎉';
}
