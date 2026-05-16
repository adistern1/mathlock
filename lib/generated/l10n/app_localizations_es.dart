// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTagline => 'Responde para desbloquear tu teléfono';

  @override
  String get solveToUnlock => 'Resuelve para desbloquear 🔓';

  @override
  String get streak => 'Racha';

  @override
  String get days => 'días';

  @override
  String get totalAnswered => 'Respondidas';

  @override
  String get practice => 'Practicar';

  @override
  String get progress => 'Progreso';

  @override
  String get parentSettings => 'Ajustes de padres';

  @override
  String get permissionNeeded => 'Permiso requerido';

  @override
  String get permissionExplain =>
      'MathLock necesita el permiso \'Mostrar sobre otras apps\' para mostrar el quiz al encender el teléfono.';

  @override
  String get grantPermission => 'Dar permiso';

  @override
  String get overlayActive =>
      'MathLock activo — aparecerá un quiz al encender la pantalla';

  @override
  String get overlayInactive => 'MathLock inactivo';

  @override
  String get notLearned => 'Sin aprender';

  @override
  String get learning => 'Aprendiendo';

  @override
  String get mastered => 'Dominado';

  @override
  String get parentArea => 'Zona de padres';

  @override
  String get enterPin => 'Introduce tu PIN de padre/madre';

  @override
  String get wrongPin => 'PIN incorrecto — inténtalo de nuevo';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get back => 'Volver';

  @override
  String get overlayEnabled => 'Quiz en pantalla de bloqueo';

  @override
  String get overlayExplain =>
      'Mostrar un quiz cada vez que se enciende el teléfono';

  @override
  String get questionsPerUnlock => 'Preguntas por desbloqueo';

  @override
  String get tableRange => 'Rango de tabla de multiplicar';

  @override
  String get max => 'Máx';

  @override
  String get changePin => 'Cambiar PIN de padre/madre';

  @override
  String get newPin => 'Nuevo PIN (4–6 dígitos)';

  @override
  String get pinChanged => 'PIN cambiado correctamente';

  @override
  String get save => 'Guardar';

  @override
  String get lockSettings => 'Bloquear ajustes';

  @override
  String get correct => '¡Correcto!';

  @override
  String get tryAgain => 'Inténtalo de nuevo';

  @override
  String get wellDone => '¡Bien hecho! Teléfono desbloqueado 🎉';
}
