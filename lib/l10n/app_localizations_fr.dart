// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'TimeTracker';

  @override
  String get loginTitle => 'Se Connecter';

  @override
  String get emailLabel => 'Adresse E-mail';

  @override
  String get passwordLabel => 'Mot de Passe';

  @override
  String get showPasswordTooltip => 'Afficher';

  @override
  String get hidePasswordTooltip => 'Masquer';

  @override
  String get loginButton => 'Connexion';

  @override
  String get registerLink => 'Pas de compte ? S\'inscrire';

  @override
  String get offlineModeMessage =>
      'Mode hors ligne - Utilisation des identifiants sauvegardés';

  @override
  String get internetRequiredMessage =>
      'Pas de connexion - Internet requis pour la première connexion';

  @override
  String get offlineFirstLoginMessage =>
      'Pas de connexion. Vous devez vous connecter en ligne d\'abord pour utiliser l\'app hors ligne.';

  @override
  String get incorrectCredentials => 'Identifiants incorrects';

  @override
  String get createAccount => 'Créer un Compte';

  @override
  String get nameLabel => 'Nom';

  @override
  String get confirmPasswordLabel => 'Confirmer le Mot de Passe';

  @override
  String get registerButton => 'S\'inscrire';

  @override
  String get registrationSuccess =>
      'Inscription réussie. Veuillez vous connecter.';

  @override
  String get allFieldsRequired => 'Tous les champs sont obligatoires';

  @override
  String get passwordMismatch => 'Les mots de passe ne correspondent pas';

  @override
  String get registrationError =>
      'Un problème est survenu lors de l\'inscription';

  @override
  String homeGreeting(String name) {
    return 'Salut, $name !';
  }

  @override
  String get startTrackingButton => 'Commencer l\'Enregistrement';

  @override
  String get menuTitle => 'Menu';

  @override
  String get homeMenuItem => 'Accueil';

  @override
  String get accountMenuItem => 'Compte';

  @override
  String get reportsMenuItem => 'Rapports';

  @override
  String get logoutMenuItem => 'Se Déconnecter';

  @override
  String get offlineModeTitle => '📱 Mode Hors Ligne';

  @override
  String get offlineModeDescription =>
      'Pas de connexion internet. Les enregistrements seront sauvegardés localement.';

  @override
  String get loginRequiredTitle => '🔐 Connexion en ligne requise';

  @override
  String loginRequiredMessage(int count) {
    return 'Vous avez $count enregistrements en attente. Pour synchroniser, vous devez vous déconnecter et vous reconnecter avec internet.';
  }

  @override
  String get logoutAndLoginButton => 'Se déconnecter et se reconnecter';

  @override
  String get syncErrorTitle =>
      '⚠️ Enregistrements avec erreur de synchronisation';

  @override
  String get pendingSyncTitle =>
      '📤 Enregistrements en attente de synchronisation';

  @override
  String syncErrorMessage(int failedCount, int pendingCount) {
    return 'Vous avez $failedCount enregistrements avec des erreurs et $pendingCount en attente';
  }

  @override
  String pendingSyncMessage(int pendingCount) {
    return 'Vous avez $pendingCount enregistrements en attente de synchronisation';
  }

  @override
  String get synchronizing => 'Synchronisation en cours...';

  @override
  String get syncNowButton => 'Synchroniser Maintenant';

  @override
  String get retryButton => 'Réessayer';

  @override
  String get logoutDialogTitle => 'Se Déconnecter';

  @override
  String get logoutDialogMessage =>
      'Pour synchroniser vos enregistrements en attente, vous devez vous déconnecter et vous reconnecter avec une connexion internet.\\n\\nVoulez-vous vous déconnecter maintenant ?';

  @override
  String get cancelButton => 'Annuler';

  @override
  String logoutErrorMessage(String error) {
    return 'Erreur lors de la déconnexion : $error';
  }

  @override
  String get step1Title => 'Étape 1 sur 7';

  @override
  String get step1Question => 'Qu\'avez-vous fait aujourd\'hui ?';

  @override
  String get step1Description =>
      'Écrivez une brève description de l\'activité que vous avez réalisée.';

  @override
  String get step1Placeholder => 'Ex: J\'ai aidé un traducteur piaroa à...';

  @override
  String get nextButton => 'Suivant';

  @override
  String get step1Validation => 'Veuillez compléter la note.';

  @override
  String get step2Title => 'Étape 2 sur 7';

  @override
  String get step2Question => 'Qui avez-vous aidé aujourd\'hui ?';

  @override
  String get recipientLabel => 'Destinataire';

  @override
  String get supportedCountryLabel => 'Pays Supporté';

  @override
  String get countryPlaceholder => 'Ex: AR, États-Unis, etc.';

  @override
  String get workingLanguageLabel => 'Langue de Travail';

  @override
  String get languagePlaceholder => 'Ex: es, en, portugais...';

  @override
  String get recipientValidation => 'Complétez le destinataire.';

  @override
  String get countryValidation => 'Le pays supporté est requis';

  @override
  String get languageValidation => 'La langue de travail est requise';

  @override
  String get savingButton => 'Sauvegarde...';

  @override
  String get continueButton => 'Continuer';

  @override
  String get step3Title => 'Étape 3 sur 7';

  @override
  String get step3Question => 'Quel est votre nom ?';

  @override
  String get step3Description =>
      'Ce nom sera utilisé pour enregistrer votre participation.';

  @override
  String get step3Placeholder => 'Ex: Jean Dupont';

  @override
  String get step3Validation => 'Complétez votre nom.';

  @override
  String get step4Title => 'Étape 4 sur 7';

  @override
  String get step4Question => 'Quand cela s\'est-il passé ?';

  @override
  String get step4Description =>
      'Sélectionnez la date de début et de fin de l\'activité.';

  @override
  String get startDateLabel => 'Début';

  @override
  String get endDateLabel => 'Fin';

  @override
  String get selectDateButton => 'Sélectionner';

  @override
  String get step4Validation => 'Veuillez compléter les deux dates.';

  @override
  String get step5Title => 'Étape 5 sur 7';

  @override
  String get step5Question => 'À quelle heure était-ce ?';

  @override
  String get step5Description =>
      'Sélectionnez l\'heure de début et de fin de l\'activité.';

  @override
  String get startTimeLabel => 'Heure de début';

  @override
  String get endTimeLabel => 'Heure de fin';

  @override
  String get step5Validation => 'Veuillez compléter les deux heures.';

  @override
  String get step6Title => 'Étape 6 sur 7';

  @override
  String get step6Question => 'Quelles tâches avez-vous effectuées ?';

  @override
  String get step6Description =>
      'Sélectionnez une ou plusieurs tâches effectuées et écrivez des détails si vous le souhaitez.';

  @override
  String get additionalDetailsPlaceholder => 'Détails supplémentaires...';

  @override
  String get step6Validation => 'Sélectionnez au moins une tâche.';

  @override
  String get step7Title => 'Étape 7 sur 7';

  @override
  String get step7Question => 'Résumé de votre activité';

  @override
  String get noteLabel => 'Note';

  @override
  String get dateLabel => 'Date';

  @override
  String get timeLabel => 'Heure';

  @override
  String get tasksLabel => 'Tâches';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get finishButton => 'Terminer';

  @override
  String get successMessage => 'Enregistrement envoyé avec succès.';

  @override
  String get errorMessage => 'Erreur lors de l\'envoi de l\'enregistrement.';

  @override
  String get taskMAST => 'MAST';

  @override
  String get taskBTTSupport => 'Support BTT (Writer, Orature, USFM, Recorder)';

  @override
  String get taskTraining => 'Formation';

  @override
  String get taskTechnicalSupport => 'Support Technique';

  @override
  String get taskVMAST => 'V-Mast';

  @override
  String get taskTranscribe => 'Transcrire';

  @override
  String get taskQualityAssurance => 'Processus d\'Assurance Qualité';

  @override
  String get taskIhadiDevelopment => 'Développement logiciel Ihadi';

  @override
  String get taskAI => 'IA';

  @override
  String get taskSpecialAssignment => 'Mission Spéciale';

  @override
  String get taskRevision => 'Révision';

  @override
  String get taskOther => 'Autre';

  @override
  String get reportsTitle => 'Rapports';

  @override
  String get selectRangeTooltip => 'Sélectionner la plage';

  @override
  String get reloadTooltip => 'Recharger';

  @override
  String roleLabel(String role) {
    return 'Rôle : $role';
  }

  @override
  String scopeLabel(String scope) {
    return 'Portée : $scope';
  }

  @override
  String get roleAdmin => 'Administrateur';

  @override
  String get roleFieldManager => 'Gestionnaire de Terrain';

  @override
  String get roleUser => 'Utilisateur';

  @override
  String get scopeAll => 'Tous';

  @override
  String get scopeMyTeam => 'Mon Équipe';

  @override
  String get scopeMyRecords => 'Mes Enregistrements';

  @override
  String get searchPlaceholder => 'Rechercher par nom, note, etc.';

  @override
  String get noTrackingsMessage => 'Aucun enregistrement à afficher';

  @override
  String loadReportsError(String error) {
    return 'Impossible de charger les rapports : $error';
  }

  @override
  String get accountTitle => 'Mon Compte';

  @override
  String get defaultUserName => 'Utilisateur';

  @override
  String get guestRole => 'Invité';

  @override
  String get verifyingAuthStatus =>
      'Vérification du statut d\'authentification...';

  @override
  String userCountryLabel(String country) {
    return 'Pays : $country';
  }

  @override
  String userRoleLabel(String role) {
    return 'Rôle : $role';
  }

  @override
  String get countryFieldLabel => 'Pays';

  @override
  String get nameRequiredValidation => 'Le nom est requis';

  @override
  String get saveChangesButton => 'Sauvegarder les Modifications';

  @override
  String get profileUpdatedMessage => 'Profil mis à jour';

  @override
  String saveErrorMessage(String error) {
    return 'Erreur lors de la sauvegarde : $error';
  }

  @override
  String genericErrorMessage(String error) {
    return 'Erreur : $error';
  }

  @override
  String get security => 'Sécurité';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get changePasswordSubtitle => 'Mettez à jour votre mot de passe';

  @override
  String get changePasswordTitle => 'Changer le mot de passe';

  @override
  String get currentPasswordLabel => 'Mot de passe actuel';

  @override
  String get newPasswordLabel => 'Nouveau mot de passe';

  @override
  String get repeatNewPasswordLabel => 'Répéter le nouveau mot de passe';

  @override
  String get changePasswordSubmit => 'Mettre à jour';

  @override
  String get changePasswordSuccess => 'Mot de passe mis à jour ✅';

  @override
  String get changePasswordErrorGeneric =>
      'Impossible de mettre à jour le mot de passe';

  @override
  String get changePasswordValidationCurrentRequired =>
      'Saisissez votre mot de passe actuel';

  @override
  String changePasswordValidationMinLength(Object min) {
    return 'Au moins $min caractères';
  }

  @override
  String get changePasswordValidationRepeatMismatch => 'Ne correspond pas';

  @override
  String get loadingMessage => 'Chargement...';

  @override
  String get noDataMessage => 'Aucune donnée';

  @override
  String get closeTooltip => 'Fermer';

  @override
  String get reportDetailTitle => 'Détail du rapport';

  @override
  String get mainDataSection => 'Données Principales';

  @override
  String get personLabel => 'Personne';

  @override
  String get supportCountryLabel => 'Pays Support';

  @override
  String get workingLanguageModalLabel => 'Langue de Travail';

  @override
  String get datesAndTimesSection => 'Dates et Horaires';

  @override
  String get startLabel => 'Début';

  @override
  String get endLabel => 'Fin';

  @override
  String get startTimeModalLabel => 'Heure Début';

  @override
  String get endTimeModalLabel => 'Heure Fin';

  @override
  String get tasksSection => 'Tâches';

  @override
  String get listLabel => 'Liste';

  @override
  String get descriptionModalLabel => 'Description';

  @override
  String get noteSection => 'Note';

  @override
  String noteDetailLabel(Object note) {
    return 'Note : $note';
  }

  @override
  String countryDetailLabel(Object country) {
    return 'Pays : $country';
  }

  @override
  String languageDetailLabel(Object language) {
    return 'Langue : $language';
  }

  @override
  String timeDetailLabel(Object time) {
    return 'Heure : $time';
  }

  @override
  String tasksDetailLabel(Object tasks) {
    return 'Tâches : $tasks';
  }

  @override
  String get noteDetailPrefix => 'Note';

  @override
  String get countryDetailPrefix => 'Pays';

  @override
  String get languageDetailPrefix => 'Langue';

  @override
  String get timeDetailPrefix => 'Heure';

  @override
  String get tasksDetailPrefix => 'Tâches';

  @override
  String get trackingFallback => 'Enregistrement';

  @override
  String get languageSelectionTitle => 'Langue';

  @override
  String connectedStatus(String connectionType) {
    return 'Connecté ($connectionType)';
  }

  @override
  String get disconnectedStatus => 'Pas de connexion';

  @override
  String get readyToSync => 'Prêt à synchroniser';

  @override
  String get syncing => 'Synchronisation en cours...';

  @override
  String get lastSyncSuccess => 'Dernière synchronisation réussie';

  @override
  String get syncError => 'Erreur de synchronisation';

  @override
  String get syncPaused => 'Synchronisation en pause';

  @override
  String get syncStatusTitle => 'État de Synchronisation';

  @override
  String get connectivityTitle => 'Connectivité';

  @override
  String get statusLabel => 'État';

  @override
  String get connectedLabel => 'Connecté';

  @override
  String get disconnectedLabel => 'Déconnecté';

  @override
  String get typeLabel => 'Type';

  @override
  String get syncTitle => 'Synchronisation';

  @override
  String get pendingEntriesLabel => 'Entrées en attente';

  @override
  String get failedEntriesLabel => 'Entrées échouées';

  @override
  String get syncButton => 'Synchroniser';

  @override
  String get closeButton => 'Fermer';

  @override
  String pendingCountLabel(int count) {
    return '$count en attente';
  }

  @override
  String failedCountLabel(int count) {
    return '$count échoués';
  }

  @override
  String get fewSecondsAgo => 'Il y a quelques secondes';

  @override
  String minutesAgo(int minutes) {
    return 'Il y a $minutes minutes';
  }

  @override
  String hoursAgo(int hours) {
    return 'Il y a $hours heures';
  }

  @override
  String get noAccessToken => 'Pas de token d\'accès';

  @override
  String httpError(int statusCode, String message) {
    return 'Erreur $statusCode: $message';
  }

  @override
  String get emptyFieldValue => '-';

  @override
  String get app_name => 'TimeTracker';

  @override
  String get login_title => 'Se connecter';

  @override
  String get login_button => 'Se connecter';

  @override
  String get logout_button => 'Se déconnecter';

  @override
  String report_items_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entrées',
      one: '1 entrée',
      zero: 'Aucune entrée',
    );
    return '$_temp0';
  }

  @override
  String get date_format_hint => 'MMM d, y • HH:mm';

  @override
  String get reportsScreenTitle => 'Rapports';

  @override
  String get teamCardTitle => 'Équipe';

  @override
  String get meCardTitle => 'Moi';

  @override
  String get teamCardSubtitle => 'Rapports le mois dernier';

  @override
  String get meCardSubtitle => 'Rapports le mois dernier';

  @override
  String get teamCardSubtitleAdmin => 'Rapports de l\'organisation (vue ADMIN)';

  @override
  String get teamCardSubtitleNonAdmin => 'Identique à \'Moi\' (accès limité)';

  @override
  String meCardSubtitleRole(Object role) {
    return 'Mes rapports ($role)';
  }

  @override
  String get dailyComparisonTitle => 'Comparaison quotidienne';

  @override
  String get myEvolutionTitle => 'Évolution (Moi)';

  @override
  String errorLabel(String error) {
    return 'Erreur: $error';
  }

  @override
  String get noReportsInPeriod => 'Aucun rapport dans la période';

  @override
  String reportIdLabel(String id) {
    return 'Rapport $id…';
  }

  @override
  String reportDateUserLabel(String date, String userId) {
    return 'Date: $date • Utilisateur: $userId…';
  }

  @override
  String reportIdField(String id) {
    return '• ID: $id';
  }

  @override
  String reportUserField(String userId) {
    return '• Utilisateur: $userId';
  }

  @override
  String reportStartDateField(String startDate) {
    return '• Date de début: $startDate';
  }

  @override
  String reportOrganizationField(String organizationId) {
    return '• Organisation: $organizationId';
  }

  @override
  String reportProjectField(String projectId) {
    return '• Projet: $projectId';
  }

  @override
  String reportNotesField(String notes) {
    return '• Notes: $notes';
  }

  @override
  String get unknownValue => '—';

  @override
  String get dashboardTitle => 'Tableau de Bord';

  @override
  String get trackingTileTitle => 'Suivi';

  @override
  String get trackingTileSubtitle => 'Démarrer et arrêter';

  @override
  String get reportsTileTitle => 'Rapports';

  @override
  String get reportsTileSubtitle => 'Temps et métriques';

  @override
  String get accountTileTitle => 'Compte';

  @override
  String get accountTileSubtitle => 'Profil et session';
}
