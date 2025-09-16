// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'TimeTracker';

  @override
  String get loginTitle => 'Fazer Login';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Senha';

  @override
  String get showPasswordTooltip => 'Mostrar';

  @override
  String get hidePasswordTooltip => 'Ocultar';

  @override
  String get loginButton => 'Entrar';

  @override
  String get registerLink => 'Não tem conta? Cadastre-se';

  @override
  String get offlineModeMessage => 'Modo offline - Usando credenciais salvas';

  @override
  String get internetRequiredMessage =>
      'Sem conexão - Internet necessária para o primeiro login';

  @override
  String get offlineFirstLoginMessage =>
      'Sem conexão. Você precisa fazer login online primeiro para usar o app offline.';

  @override
  String get incorrectCredentials => 'Credenciais incorretas';

  @override
  String get createAccount => 'Criar Conta';

  @override
  String get nameLabel => 'Nome';

  @override
  String get confirmPasswordLabel => 'Confirmar Senha';

  @override
  String get registerButton => 'Cadastrar';

  @override
  String get registrationSuccess =>
      'Cadastro realizado com sucesso. Por favor, faça login.';

  @override
  String get allFieldsRequired => 'Todos os campos são obrigatórios';

  @override
  String get passwordMismatch => 'As senhas não coincidem';

  @override
  String get registrationError => 'Houve um problema ao se cadastrar';

  @override
  String homeGreeting(String name) {
    return 'Oi, $name!';
  }

  @override
  String get startTrackingButton => 'Iniciar Registro';

  @override
  String get menuTitle => 'Menu';

  @override
  String get homeMenuItem => 'Início';

  @override
  String get accountMenuItem => 'Conta';

  @override
  String get reportsMenuItem => 'Relatórios';

  @override
  String get logoutMenuItem => 'Sair';

  @override
  String get offlineModeTitle => '📱 Modo Offline';

  @override
  String get offlineModeDescription =>
      'Sem conexão à internet. Os registros serão salvos localmente.';

  @override
  String get loginRequiredTitle => '🔐 É necessário fazer login online';

  @override
  String loginRequiredMessage(int count) {
    return 'Você tem $count registros pendentes. Para sincronizar, você precisa sair e fazer login com internet.';
  }

  @override
  String get logoutAndLoginButton => 'Sair e fazer login';

  @override
  String get syncErrorTitle => '⚠️ Registros com erro de sincronização';

  @override
  String get pendingSyncTitle => '📤 Registros pendentes para sincronizar';

  @override
  String syncErrorMessage(int failedCount, int pendingCount) {
    return 'Você tem $failedCount registros com erros e $pendingCount pendentes';
  }

  @override
  String pendingSyncMessage(int pendingCount) {
    return 'Você tem $pendingCount registros aguardando sincronização';
  }

  @override
  String get synchronizing => 'Sincronizando...';

  @override
  String get syncNowButton => 'Sincronizar Agora';

  @override
  String get retryButton => 'Tentar Novamente';

  @override
  String get logoutDialogTitle => 'Sair';

  @override
  String get logoutDialogMessage =>
      'Para sincronizar seus registros pendentes, você precisa sair e fazer login novamente com conexão à internet.\\n\\nDeseja sair agora?';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String logoutErrorMessage(String error) {
    return 'Erro ao sair: $error';
  }

  @override
  String get step1Title => 'Passo 1 de 7';

  @override
  String get step1Question => 'O que você fez hoje?';

  @override
  String get step1Description =>
      'Escreva uma breve descrição da atividade que você realizou.';

  @override
  String get step1Placeholder => 'Ex: Ajudei um tradutor piaroa a...';

  @override
  String get nextButton => 'Próximo';

  @override
  String get step1Validation => 'Por favor, complete a nota.';

  @override
  String get step2Title => 'Passo 2 de 7';

  @override
  String get step2Question => 'Quem você ajudou hoje?';

  @override
  String get recipientLabel => 'Destinatário';

  @override
  String get supportedCountryLabel => 'País Apoiado';

  @override
  String get countryPlaceholder => 'Ex: AR, Estados Unidos, etc.';

  @override
  String get workingLanguageLabel => 'Idioma de Trabalho';

  @override
  String get languagePlaceholder => 'Ex: es, en, português...';

  @override
  String get recipientValidation => 'Complete o destinatário.';

  @override
  String get countryValidation => 'O país apoiado é obrigatório';

  @override
  String get languageValidation => 'O idioma de trabalho é obrigatório';

  @override
  String get savingButton => 'Salvando...';

  @override
  String get continueButton => 'Continuar';

  @override
  String get step3Title => 'Passo 3 de 7';

  @override
  String get step3Question => 'Qual é o seu nome?';

  @override
  String get step3Description =>
      'Este nome será usado para registrar sua participação.';

  @override
  String get step3Placeholder => 'Ex: João Silva';

  @override
  String get step3Validation => 'Complete seu nome.';

  @override
  String get step4Title => 'Passo 4 de 7';

  @override
  String get step4Question => 'Quando aconteceu?';

  @override
  String get step4Description =>
      'Selecione a data de início e fim da atividade.';

  @override
  String get startDateLabel => 'Início';

  @override
  String get endDateLabel => 'Fim';

  @override
  String get selectDateButton => 'Selecionar';

  @override
  String get step4Validation => 'Por favor, complete ambas as datas.';

  @override
  String get step5Title => 'Passo 5 de 7';

  @override
  String get step5Question => 'Em que horário foi?';

  @override
  String get step5Description =>
      'Selecione a hora de início e fim da atividade.';

  @override
  String get startTimeLabel => 'Hora de início';

  @override
  String get endTimeLabel => 'Hora de fim';

  @override
  String get step5Validation => 'Por favor, complete ambos os horários.';

  @override
  String get step6Title => 'Passo 6 de 7';

  @override
  String get step6Question => 'Quais tarefas você realizou?';

  @override
  String get step6Description =>
      'Selecione uma ou mais tarefas realizadas e escreva detalhes se desejar.';

  @override
  String get additionalDetailsPlaceholder => 'Detalhes adicionais...';

  @override
  String get step6Validation => 'Selecione pelo menos uma tarefa.';

  @override
  String get step7Title => 'Passo 7 de 7';

  @override
  String get step7Question => 'Resumo da sua atividade';

  @override
  String get noteLabel => 'Nota';

  @override
  String get dateLabel => 'Data';

  @override
  String get timeLabel => 'Horário';

  @override
  String get tasksLabel => 'Tarefas';

  @override
  String get descriptionLabel => 'Descrição';

  @override
  String get finishButton => 'Finalizar';

  @override
  String get successMessage => 'Registro enviado com sucesso.';

  @override
  String get errorMessage => 'Erro ao enviar o registro.';

  @override
  String get taskMAST => 'MAST';

  @override
  String get taskBTTSupport => 'Suporte BTT (Writer, Orature, USFM, Recorder)';

  @override
  String get taskTraining => 'Treinamento';

  @override
  String get taskTechnicalSupport => 'Suporte Técnico';

  @override
  String get taskVMAST => 'V-Mast';

  @override
  String get taskTranscribe => 'Transcrever';

  @override
  String get taskQualityAssurance => 'Processos de Garantia de Qualidade';

  @override
  String get taskIhadiDevelopment => 'Desenvolvimento de software Ihadi';

  @override
  String get taskAI => 'IA';

  @override
  String get taskSpecialAssignment => 'Missão Especial';

  @override
  String get taskRevision => 'Revisão';

  @override
  String get taskOther => 'Outro';

  @override
  String get reportsTitle => 'Relatórios';

  @override
  String get selectRangeTooltip => 'Selecionar intervalo';

  @override
  String get reloadTooltip => 'Recarregar';

  @override
  String roleLabel(String role) {
    return 'Função: $role';
  }

  @override
  String scopeLabel(String scope) {
    return 'Escopo: $scope';
  }

  @override
  String get roleAdmin => 'Administrador';

  @override
  String get roleFieldManager => 'Gerente de Campo';

  @override
  String get roleUser => 'Usuário';

  @override
  String get scopeAll => 'Todos';

  @override
  String get scopeMyTeam => 'Minha Equipe';

  @override
  String get scopeMyRecords => 'Meus Registros';

  @override
  String get searchPlaceholder => 'Buscar por nome, nota, etc.';

  @override
  String get noTrackingsMessage => 'Nenhum registro para exibir';

  @override
  String loadReportsError(String error) {
    return 'Não foi possível carregar os relatórios: $error';
  }

  @override
  String get accountTitle => 'Minha Conta';

  @override
  String get defaultUserName => 'Usuário';

  @override
  String get guestRole => 'Convidado';

  @override
  String get verifyingAuthStatus => 'Verificando status de autenticação...';

  @override
  String userCountryLabel(String country) {
    return 'País: $country';
  }

  @override
  String userRoleLabel(String role) {
    return 'Função: $role';
  }

  @override
  String get countryFieldLabel => 'País';

  @override
  String get nameRequiredValidation => 'O nome é obrigatório';

  @override
  String get saveChangesButton => 'Salvar Alterações';

  @override
  String get profileUpdatedMessage => 'Perfil atualizado';

  @override
  String saveErrorMessage(String error) {
    return 'Erro ao salvar: $error';
  }

  @override
  String genericErrorMessage(String error) {
    return 'Erro: $error';
  }

  @override
  String get loadingMessage => 'Carregando...';

  @override
  String get noDataMessage => 'Sem dados';

  @override
  String get closeTooltip => 'Fechar';

  @override
  String get reportDetailTitle => 'Detalhe do Relatório';

  @override
  String get mainDataSection => 'Dados Principais';

  @override
  String get personLabel => 'Pessoa';

  @override
  String get supportCountryLabel => 'País Apoio';

  @override
  String get workingLanguageModalLabel => 'Idioma de Trabalho';

  @override
  String get datesAndTimesSection => 'Datas e Horários';

  @override
  String get startLabel => 'Início';

  @override
  String get endLabel => 'Fim';

  @override
  String get startTimeModalLabel => 'Hora Início';

  @override
  String get endTimeModalLabel => 'Hora Fim';

  @override
  String get tasksSection => 'Tarefas';

  @override
  String get listLabel => 'Lista';

  @override
  String get descriptionModalLabel => 'Descrição';

  @override
  String get noteSection => 'Nota';

  @override
  String noteDetailLabel(Object note) {
    return 'Nota: $note';
  }

  @override
  String countryDetailLabel(Object country) {
    return 'País: $country';
  }

  @override
  String languageDetailLabel(Object language) {
    return 'Idioma: $language';
  }

  @override
  String timeDetailLabel(Object time) {
    return 'Horário: $time';
  }

  @override
  String tasksDetailLabel(Object tasks) {
    return 'Tarefas: $tasks';
  }

  @override
  String get noteDetailPrefix => 'Nota';

  @override
  String get countryDetailPrefix => 'País';

  @override
  String get languageDetailPrefix => 'Idioma';

  @override
  String get timeDetailPrefix => 'Horário';

  @override
  String get tasksDetailPrefix => 'Tarefas';

  @override
  String get trackingFallback => 'Registro';

  @override
  String get languageSelectionTitle => 'Idioma';

  @override
  String connectedStatus(String connectionType) {
    return 'Conectado ($connectionType)';
  }

  @override
  String get disconnectedStatus => 'Sem conexão';

  @override
  String get readyToSync => 'Pronto para sincronizar';

  @override
  String get syncing => 'Sincronizando...';

  @override
  String get lastSyncSuccess => 'Última sincronização bem-sucedida';

  @override
  String get syncError => 'Erro de sincronização';

  @override
  String get syncPaused => 'Sincronização pausada';

  @override
  String get syncStatusTitle => 'Status de Sincronização';

  @override
  String get connectivityTitle => 'Conectividade';

  @override
  String get statusLabel => 'Status';

  @override
  String get connectedLabel => 'Conectado';

  @override
  String get disconnectedLabel => 'Desconectado';

  @override
  String get typeLabel => 'Tipo';

  @override
  String get syncTitle => 'Sincronização';

  @override
  String get pendingEntriesLabel => 'Entradas pendentes';

  @override
  String get failedEntriesLabel => 'Entradas falhadas';

  @override
  String get syncButton => 'Sincronizar';

  @override
  String get closeButton => 'Fechar';

  @override
  String pendingCountLabel(int count) {
    return '$count pendentes';
  }

  @override
  String failedCountLabel(int count) {
    return '$count falharam';
  }

  @override
  String get fewSecondsAgo => 'Há alguns segundos';

  @override
  String minutesAgo(int minutes) {
    return 'Há $minutes minutos';
  }

  @override
  String hoursAgo(int hours) {
    return 'Há $hours horas';
  }

  @override
  String get noAccessToken => 'Sem token de acesso';

  @override
  String httpError(int statusCode, String message) {
    return 'Erro $statusCode: $message';
  }

  @override
  String get emptyFieldValue => '-';

  @override
  String get app_name => 'TimeTracker';

  @override
  String get login_title => 'Fazer login';

  @override
  String get login_button => 'Fazer login';

  @override
  String get logout_button => 'Sair';

  @override
  String report_items_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entradas',
      one: '1 entrada',
      zero: 'Nenhuma entrada',
    );
    return '$_temp0';
  }

  @override
  String get date_format_hint => 'MMM d, y • HH:mm';
}
