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
  String get forgotPassword => 'Mot de passe oublié';

  @override
  String get forgotPasswordTitle => 'Récupérer le mot de passe';

  @override
  String get forgotPasswordInstruction =>
      'Entrez votre e-mail et nous vous enverrons un lien pour réinitialiser votre mot de passe.';

  @override
  String get emailRequired => 'Saisissez votre e-mail';

  @override
  String get invalidEmail => 'E-mail invalide';

  @override
  String get sendButton => 'Envoyer';

  @override
  String get forgotPasswordSent => 'Vérifiez votre e-mail';

  @override
  String get forgotPasswordErrorGeneric =>
      'Impossible d’envoyer l’e-mail de récupération';

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
  String get taskRefinement => 'Raffinement';

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
  String get myTrackingsOnly => 'Mes trackings seulement';

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
  String get period => 'Période';

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

  @override
  String get enhancedReportsTitle => 'Rapports Avancés';

  @override
  String get advancedReportsTooltip => 'Rapports Avancés';

  @override
  String get basicReportsTitle => 'Rapports de Base';

  @override
  String get regionalReportsTitle => 'Rapports Régionaux';

  @override
  String get regionalSummaryTitle => 'RÉSUMÉ RÉGIONAL :';

  @override
  String get regionalComparisonTitle => 'Comparaison Régionale';

  @override
  String get countryBreakdownTitle => 'Répartition par Pays';

  @override
  String get languageDistributionTitle => 'Distribution des Langues';

  @override
  String get regionalDashboard => 'Panel régional';

  @override
  String get roleBasedAccess => 'Accès basé sur le rôle';

  @override
  String get accessLevel => 'Niveau d\'Accès';

  @override
  String get availableReports => 'Rapports Disponibles';

  @override
  String get selectRegionForDetails =>
      'Sélectionnez une région pour voir les détails';

  @override
  String get compareRegions => 'Comparer les Régions';

  @override
  String get viewCountryBreakdown => 'Voir la Répartition par Pays';

  @override
  String get analyzeLanguageDistribution =>
      'Analyser la Distribution des Langues';

  @override
  String get activeFiltersTitle => 'Filtres Actifs';

  @override
  String get clearFilters => 'Effacer les Filtres';

  @override
  String get filterByRegion => 'Filtrer par région';

  @override
  String get filterByDates => 'Filtrer par dates';

  @override
  String get allRegions => 'Toutes les régions';

  @override
  String get selectRegions => 'Sélectionner les Régions';

  @override
  String get selectAtLeast2Regions =>
      'Sélectionnez au moins 2 régions à comparer';

  @override
  String selectedRegionsCount(int count) {
    return 'Régions Sélectionnées ($count/10)';
  }

  @override
  String get totalHours => 'Total Heures';

  @override
  String get totalEntries => 'Total d\'Entrées';

  @override
  String get activeUsers => 'Utilisateurs Actifs';

  @override
  String get totalLanguages => 'Total de Langues';

  @override
  String get totalCountries => 'Total de Pays';

  @override
  String get totalRegions => 'Régions';

  @override
  String get averagePerRegion => 'Moyenne/Région';

  @override
  String get averagePerCountry => 'Moyenne/Pays';

  @override
  String get averagePerLanguage => 'Moyenne/Langue';

  @override
  String get topCountries => 'Principaux Pays';

  @override
  String get languageBreakdown => 'Répartition des Langues';

  @override
  String get performanceMetrics => 'Métriques de Performance';

  @override
  String get comparisonSummary => 'Résumé de Comparaison';

  @override
  String get detailedMetrics => 'Métriques Détaillées';

  @override
  String get performanceHighlights => 'Faits Saillants de Performance';

  @override
  String get mainMetrics => 'Principaux indicateurs';

  @override
  String get metricTotalHours => 'Heures Totales';

  @override
  String get metricTotalEntries => 'Entrées Totales';

  @override
  String get metricActiveUsers => 'Utilisateurs Actifs';

  @override
  String get metricAverageHoursPerUser => 'Heures Moyennes par Utilisateur';

  @override
  String get metricAverageHoursPerEntry => 'Heures Moyennes par Entrée';

  @override
  String get metricProductivityScore => 'Score de Productivité';

  @override
  String get metricCompletionRate => 'Taux d\'Achèvement';

  @override
  String get metricResponseTime => 'Temps de Réponse';

  @override
  String get metricQualityScore => 'Score de Qualité';

  @override
  String get metricEfficiencyRating => 'Notation d\'Efficacité';

  @override
  String get metricWeeklyHours => 'Heures Hebdomadaires';

  @override
  String get metricMonthlyHours => 'Heures Mensuelles';

  @override
  String get metricPeakHours => 'Heures de Pointe';

  @override
  String get metricOffPeakHours => 'Heures Creuses';

  @override
  String get metricTeamCollaboration => 'Collaboration d\'Équipe';

  @override
  String get metricResourceUtilization => 'Utilisation des Ressources';

  @override
  String get metricTaskCompletion => 'Achèvement des Tâches';

  @override
  String get metricPerformanceIndex => 'Indice de Performance';

  @override
  String errorLoadingSummary(String error) {
    return 'Erreur de chargement du résumé: $error';
  }

  @override
  String get noDataAvailableForRegion =>
      'Aucune donnée disponible pour cette région';

  @override
  String get activeFilters => 'Filtres Actifs';

  @override
  String countriesFilter(String countries) {
    return 'Pays: $countries';
  }

  @override
  String languagesFilter(String languages) {
    return 'Langues: $languages';
  }

  @override
  String get mostUsed => 'Le Plus Utilisé';

  @override
  String get leastUsed => 'Le Moins Utilisé';

  @override
  String get mostActive => 'Le Plus Actif';

  @override
  String get leastActive => 'Le Moins Actif';

  @override
  String get bestPerformance => 'Meilleure Performance';

  @override
  String get worstPerformance => 'Pire Performance';

  @override
  String get hoursPerUser => 'Heures/Utilisateur';

  @override
  String get entriesPerUser => 'Entrées/Utilisateur';

  @override
  String languagesUsed(Object languages) {
    return 'Langues utilisées: $languages';
  }

  @override
  String get countriesWithActivity => 'Pays avec Activité';

  @override
  String get languagesWithActivity => 'Langues avec Activité';

  @override
  String get periodInformation => 'Informations sur la Période';

  @override
  String fromDate(String date) {
    return 'Du: $date';
  }

  @override
  String toDate(String date) {
    return 'Au: $date';
  }

  @override
  String regionScope(String region) {
    return 'Région: $region';
  }

  @override
  String get allRegionsScope => 'Portée: Toutes les régions';

  @override
  String filteredCountry(String country) {
    return 'Pays filtré: $country';
  }

  @override
  String get noDataAvailable => 'Aucune donnée disponible';

  @override
  String get noDataForRegion => 'Aucune donnée disponible pour cette région';

  @override
  String get loadingData => 'Chargement des données...';

  @override
  String get refreshData => 'Actualiser';

  @override
  String get exportReport => 'Exporter le Rapport';

  @override
  String get generateReport => 'Générer le Rapport';

  @override
  String get exportToPDF => 'Exporter en PDF';

  @override
  String get exportToExcel => 'Exporter en Excel';

  @override
  String get exportToCSV => 'Exporter en CSV';

  @override
  String get shareReport => 'Partager le Rapport';

  @override
  String get distributionChart => 'Graphique de Distribution';

  @override
  String get comparisonChart => 'Graphique de Comparaison';

  @override
  String get detailsTable => 'Table des Détails';

  @override
  String get statisticsInsights => 'Statistiques et Insights';

  @override
  String get regionalDistribution => 'Distribution Régionale';

  @override
  String get selectItemsToExport => 'Sélectionner les éléments à exporter';

  @override
  String get exportOptions => 'Options d\'Exportation';

  @override
  String get includeCharts => 'Inclure les graphiques';

  @override
  String get includeRawData => 'Inclure les données brutes';

  @override
  String get includeSummary => 'Inclure le résumé';

  @override
  String get exportSuccess => 'Rapport exporté avec succès';

  @override
  String exportError(String error) {
    return 'Erreur lors de l\'exportation: $error';
  }

  @override
  String get cancel => 'Annuler';

  @override
  String get compare => 'Comparer';

  @override
  String get apply => 'Appliquer';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get advancedReportsScreenTitle => 'Rapports Avancés';

  @override
  String get userAccessLevelTitle => 'Votre niveau d\'accès';

  @override
  String get personalDashboardTitle =>
      'Tableau de Bord Personnel (30 derniers jours)';

  @override
  String get myEntriesTitle => 'Mes Entrées';

  @override
  String get teamTitle => 'Équipe';

  @override
  String get totalHoursTitle => 'Total Heures';

  @override
  String get activeUsersTitle => 'Utilisateurs Actifs';

  @override
  String get activeRegionsTitle => 'Régions Actives';

  @override
  String get mostActiveRegionsTitle => 'Régions les Plus Actives';

  @override
  String get advancedReportsTitle => 'Rapports Avancés';

  @override
  String get compareRegionsTitle => 'Comparer les Régions';

  @override
  String get byCountriesTitle => 'Par Pays';

  @override
  String get byLanguagesTitle => 'Par Langues';

  @override
  String get compareRegionsSubtitle => 'Analyser plusieurs régions';

  @override
  String get byCountriesSubtitle => 'Répartition par pays';

  @override
  String get byLanguagesSubtitle => 'Distribution des langues';

  @override
  String get dailyComparisonSubtitle => 'Moi vs Équipe';

  @override
  String availableRegionsTitle(Object count) {
    return 'Régions Disponibles ($count)';
  }

  @override
  String get regionalAccessEnabled => 'Accès aux rapports régionaux activé';

  @override
  String get teamReportsIncludingYours =>
      'Rapports d\'équipe (y compris les vôtres)';

  @override
  String get noBasicDashboardData =>
      'Aucune donnée de tableau de bord de base disponible';

  @override
  String get noRegionalData => 'Aucune donnée régionale disponible';

  @override
  String get analysisMultipleRegions => 'Analyse de plusieurs régions';

  @override
  String get at2RegionsRequired =>
      'Au moins 2 régions nécessaires pour comparer';

  @override
  String get updateData => 'Mettre à jour les données';

  @override
  String get hours => 'Heures';

  @override
  String get dashboardComplete => 'Tableau de Bord Complet';

  @override
  String get generalSummaryMetrics => 'Résumé général et métriques de base';

  @override
  String get regionalDataComparisons => 'Données régionales et comparaisons';

  @override
  String get noBasicDashboardDataAvailable =>
      'Aucune donnée de tableau de bord de base disponible';

  @override
  String get noRegionalDataAvailable => 'Aucune donnée régionale disponible';

  @override
  String get needAtLeast2RegionsCompare =>
      'Au moins 2 régions nécessaires pour comparer';

  @override
  String get updateDataTooltip => 'Mettre à jour les données';

  @override
  String get myReports => 'Mes Rapports';

  @override
  String get teamReports => 'Rapports d\'Équipe';

  @override
  String get userRole => 'Utilisateur';

  @override
  String get meLabel => 'Moi';

  @override
  String get teamLabel => 'Équipe';

  @override
  String errorLoadingReports(Object error) {
    return 'Erreur lors du chargement des rapports : $error';
  }

  @override
  String get dashboardReport => 'Rapport de Tableau de Bord';

  @override
  String get basicDashboardReport => 'Rapport de Tableau de Bord de Base';

  @override
  String get generated => 'Généré';

  @override
  String get user => 'Utilisateur';

  @override
  String get role => 'Rôle';

  @override
  String get unknown => 'Inconnu';

  @override
  String get dashboardMetrics => 'Métriques du Tableau de Bord';

  @override
  String get teamCount => 'Compteur d\'Équipe';

  @override
  String get meCount => 'Mon Compteur';

  @override
  String get dailyComparison => 'Comparaison Quotidienne';

  @override
  String get day => 'Jour';

  @override
  String get myCount => 'Mon Compteur';

  @override
  String get myTrend => 'Ma Tendance';

  @override
  String get count => 'Compteur';

  @override
  String get regionalDashboardReport => 'Rapport de Tableau de Bord Régional';

  @override
  String get summary => 'Résumé';

  @override
  String get regionalSummary => 'Résumé Régional';

  @override
  String get country => 'Pays';

  @override
  String get percentage => 'Pourcentage';

  @override
  String get topLanguages => 'Principales Langues';

  @override
  String get language => 'Langue';

  @override
  String get dashboardMetricsTitle => 'MÉTRIQUES DU TABLEAU DE BORD :';

  @override
  String get dailyComparisonTitleHeader => 'COMPARAISON QUOTIDIENNE :';

  @override
  String get myTrendTitle => 'MA TENDANCE :';

  @override
  String get topCountriesTitle => 'PRINCIPAUX PAYS :';

  @override
  String get topLanguagesTitle => 'PRINCIPALES LANGUES :';

  @override
  String get regionalComparison => 'Comparaison Régionale';

  @override
  String errorComparingRegions(Object error) {
    return 'Erreur lors de la comparaison des régions : $error';
  }

  @override
  String get regionalComparisonReportSubject =>
      'Rapport de Comparaison Régionale';

  @override
  String selectedRegions(Object count) {
    return 'Régions Sélectionnées ($count/10)';
  }

  @override
  String get selectAtLeast2RegionsToCompare =>
      'Sélectionnez au moins 2 régions à comparer';

  @override
  String get regions => 'Régions';

  @override
  String get totalHoursComparison => 'Comparaison des Heures Totales';

  @override
  String get region => 'Région';

  @override
  String get entries => 'Entrées';

  @override
  String get users => 'Utilisateurs';

  @override
  String get hrsPerUser => 'Hrs/Utilisateur';

  @override
  String get topCountry => 'Principal Pays';

  @override
  String get topLanguage => 'Principale Langue';

  @override
  String get selectRegionsDialog => 'Sélectionner les Régions';

  @override
  String selectBetween2And10Regions(Object count) {
    return 'Sélectionnez entre 2 et 10 régions ($count sélectionnées)';
  }

  @override
  String get countryBreakdown => 'Répartition par Pays';

  @override
  String get averageHrsPerUser => 'Moyenne hrs/utilisateur';

  @override
  String get averageEntriesPerUser => 'Moyenne entrées/utilisateur';

  @override
  String get generalSummaryAndMetrics => 'Résumé général et métriques de base';

  @override
  String get regionalDataAndComparisons => 'Données régionales et comparaisons';

  @override
  String get atLeast2RegionsRequired =>
      'Au moins 2 régions requises pour la comparaison';

  @override
  String get noRegionalDataAvailableMessage =>
      'Aucune donnée régionale disponible';

  @override
  String errorLoadingData(Object error) {
    return 'Erreur lors du chargement des données: $error';
  }

  @override
  String get countryBreakdownReportSubject => 'Rapport de Répartition par Pays';

  @override
  String get selectedRegion => 'Région sélectionnée';

  @override
  String countries(Object countries) {
    return 'Pays: $countries';
  }

  @override
  String get generalSummary => 'Résumé Général';

  @override
  String get countryDistribution => 'Distribution par Pays (Top 10)';

  @override
  String countryDetails(Object count) {
    return 'Détails par Pays ($count)';
  }

  @override
  String get averageHoursPerCountry => 'Moyenne Heures/Pays';

  @override
  String get activeCountries => 'Pays Actifs';

  @override
  String from(Object date) {
    return 'Depuis: $date';
  }

  @override
  String to(Object date) {
    return 'Jusqu\'à: $date';
  }

  @override
  String errorLoadingLanguageData(Object error) {
    return 'Erreur lors du chargement des données: $error';
  }

  @override
  String get languageDistributionReportSubject =>
      'Rapport de Distribution des Langues';

  @override
  String get languageDistribution => 'Distribution des Langues';

  @override
  String languages(Object languages) {
    return 'Langues: $languages';
  }

  @override
  String get hoursPerLanguage => 'Heures par Langue';

  @override
  String languageDetails(Object count) {
    return 'Détails par Langues ($count)';
  }

  @override
  String countriesWhereUsed(Object countries) {
    return 'Pays où utilisé: $countries';
  }

  @override
  String get regionalLanguageDistribution =>
      'Distribution Régionale des Langues (Top 5)';

  @override
  String get averageHoursPerLanguage => 'Moyenne Heures/Langue';

  @override
  String get activeLanguages => 'Langues Actives';

  @override
  String countryFiltered(Object country) {
    return 'Pays filtré: $country';
  }

  @override
  String get regionalSummaryReport => 'Rapport de Résumé Régional';

  @override
  String get topCountriesLabel => 'Principaux Pays';

  @override
  String get languageBreakdownLabel => 'Répartition des Langues';

  @override
  String get regionalComparisonReport => 'Rapport de Comparaison Régionale';

  @override
  String get averageHoursPerRegion => 'Moyenne d\'Heures par Région';

  @override
  String get regionalDataLabel => 'Données Régionales';

  @override
  String get avgHoursPerUser => 'Moy Heures/Utilisateur';

  @override
  String get countryBreakdownReport => 'Rapport de Répartition par Pays';

  @override
  String get countryDetailsLabel => 'Détails par Pays';

  @override
  String get rank => 'Rang';

  @override
  String get avgEntriesPerUser => 'Moy Entrées/Utilisateur';

  @override
  String get languageColumn => 'Langues';

  @override
  String get languageDistributionReport =>
      'Rapport de Distribution des Langues';

  @override
  String get languageDetailsLabel => 'Détails par Langues';

  @override
  String get countryColumn => 'Pays';
}
