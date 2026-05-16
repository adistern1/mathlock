// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTagline => 'أجب لفتح هاتفك';

  @override
  String get solveToUnlock => 'أحل لفتح الهاتف 🔓';

  @override
  String get streak => 'سلسلة';

  @override
  String get days => 'أيام';

  @override
  String get totalAnswered => 'أجبت';

  @override
  String get practice => 'تدرب';

  @override
  String get progress => 'التقدم';

  @override
  String get parentSettings => 'إعدادات الوالدين';

  @override
  String get permissionNeeded => 'إذن مطلوب';

  @override
  String get permissionExplain =>
      'يحتاج MathLock إذن \'العرض فوق التطبيقات الأخرى\' لعرض السؤال عند تشغيل الهاتف.';

  @override
  String get grantPermission => 'منح الإذن';

  @override
  String get overlayActive => 'MathLock نشط — سيظهر سؤال عند تشغيل الشاشة';

  @override
  String get overlayInactive => 'MathLock غير نشط';

  @override
  String get notLearned => 'لم يُتعلم';

  @override
  String get learning => 'يتعلم';

  @override
  String get mastered => 'متقن';

  @override
  String get parentArea => 'منطقة الوالدين';

  @override
  String get enterPin => 'أدخل رمز الوالدين';

  @override
  String get wrongPin => 'رمز خاطئ — حاول مجددًا';

  @override
  String get unlock => 'فتح';

  @override
  String get back => 'رجوع';

  @override
  String get overlayEnabled => 'اختبار شاشة القفل';

  @override
  String get overlayExplain => 'اعرض سؤالًا في كل مرة يُشغَّل فيها الهاتف';

  @override
  String get questionsPerUnlock => 'أسئلة لكل فتح';

  @override
  String get tableRange => 'نطاق جدول الضرب';

  @override
  String get max => 'الحد الأقصى';

  @override
  String get changePin => 'تغيير رمز الوالدين';

  @override
  String get newPin => 'رمز جديد (4–6 أرقام)';

  @override
  String get pinChanged => 'تم تغيير الرمز بنجاح';

  @override
  String get save => 'حفظ';

  @override
  String get lockSettings => 'قفل الإعدادات';

  @override
  String get correct => 'صحيح!';

  @override
  String get tryAgain => 'حاول مجددًا';

  @override
  String get wellDone => 'أحسنت! الهاتف مفتوح 🎉';
}
