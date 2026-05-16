// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTagline => 'Réponds pour déverrouiller ton téléphone';

  @override
  String get solveToUnlock => 'Résous pour déverrouiller 🔓';

  @override
  String get streak => 'Série';

  @override
  String get days => 'jours';

  @override
  String get totalAnswered => 'Répondu';

  @override
  String get practice => 'Pratiquer';

  @override
  String get progress => 'Progrès';

  @override
  String get parentSettings => 'Paramètres parentaux';

  @override
  String get permissionNeeded => 'Permission requise';

  @override
  String get permissionExplain =>
      'MathLock a besoin de la permission \'Afficher par-dessus les autres apps\' pour afficher le quiz à l\'allumage du téléphone.';

  @override
  String get grantPermission => 'Accorder la permission';

  @override
  String get overlayActive =>
      'MathLock actif — un quiz apparaîtra à l\'allumage de l\'écran';

  @override
  String get overlayInactive => 'MathLock inactif';

  @override
  String get notLearned => 'Non appris';

  @override
  String get learning => 'En cours';

  @override
  String get mastered => 'Maîtrisé';

  @override
  String get parentArea => 'Zone parents';

  @override
  String get enterPin => 'Entre ton code parent';

  @override
  String get wrongPin => 'Code incorrect — réessaie';

  @override
  String get unlock => 'Déverrouiller';

  @override
  String get back => 'Retour';

  @override
  String get overlayEnabled => 'Quiz sur l\'écran de verrouillage';

  @override
  String get overlayExplain =>
      'Afficher un quiz à chaque allumage du téléphone';

  @override
  String get questionsPerUnlock => 'Questions par déverrouillage';

  @override
  String get tableRange => 'Plage de la table de multiplication';

  @override
  String get max => 'Max';

  @override
  String get changePin => 'Changer le code parent';

  @override
  String get newPin => 'Nouveau code (4–6 chiffres)';

  @override
  String get pinChanged => 'Code modifié avec succès';

  @override
  String get save => 'Enregistrer';

  @override
  String get lockSettings => 'Verrouiller les paramètres';

  @override
  String get correct => 'Correct !';

  @override
  String get tryAgain => 'Réessaie';

  @override
  String get wellDone => 'Bravo ! Téléphone déverrouillé 🎉';
}
