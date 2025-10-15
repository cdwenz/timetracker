import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';

import '../widgets/custom_drawer.dart';
import '../widgets/big_action_button.dart';
import '../widgets/offline_status_widget.dart';
import '../services/sync_service.dart';
import '../services/connectivity_service.dart';
import 'reports_screen.dart';
import 'account_screen.dart';
import 'tracking_steps_screens/step_01_screen.dart';

// helper local, mismo patrón que el Drawer
void _go(BuildContext context, Widget page, {bool replace = false}) {
  if (replace) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  } else {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = '';
  String _role = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('name') ??
          AppLocalizations.of(context).defaultUserName;
      _role = prefs.getString('role') ?? AppLocalizations.of(context).guestRole;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      drawerEnableOpenDragGesture: true,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).dashboardTitle),
        actions: const [
          OfflineStatusWidget(compact: true),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Widget de notificación de sincronización
            _buildSyncNotification(),

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // 2 columnas en móvil, 3 si hay ancho grande
                  final crossAxisCount = constraints.maxWidth >= 900
                      ? 3
                      : constraints.maxWidth >= 600
                          ? 3
                          : 2;

                  return GridView.count(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.35,
                    children: [
                      _DashboardTile(
                        title: AppLocalizations.of(context).trackingTileTitle,
                        subtitle:
                            AppLocalizations.of(context).trackingTileSubtitle,
                        icon: Icons.timer_outlined,
                        onTap: () =>
                            _go(context, const StepOneScreen(), replace: true),
                      ),
                      _DashboardTile(
                        title: AppLocalizations.of(context).reportsTileTitle,
                        subtitle:
                            AppLocalizations.of(context).reportsTileSubtitle,
                        icon: Icons.bar_chart_rounded,
                        onTap: () =>
                            _go(context, const ReportsScreen(), replace: true),
                      ),
                      _DashboardTile(
                        title: AppLocalizations.of(context).accountTileTitle,
                        subtitle:
                            AppLocalizations.of(context).accountTileSubtitle,
                        icon: Icons.person_rounded,
                        onTap: () =>
                            _go(context, const AccountScreen(), replace: true),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construir notificación unificada de sincronización
  Widget _buildSyncNotification() {
    return Consumer2<SyncService, ConnectivityService>(
      builder: (context, syncService, connectivityService, child) {
        final pendingCount = syncService.pendingSyncCount;
        final failedCount = syncService.failedSyncCount;
        final totalPending = pendingCount + failedCount;
        final isConnected = connectivityService.isConnected;

        // Caso 1: Sin conexión - mostrar estado offline
        if (!isConnected) {
          return _buildOfflineStatus(connectivityService);
        }

        // Caso 2: Conectado con registros pendientes
        if (isConnected && totalPending > 0) {
          return _buildSyncNotificationWithTokenCheck(
              syncService, pendingCount, failedCount, totalPending);
        }

        // Caso 3: Todo sincronizado - no mostrar nada
        return const SizedBox.shrink();
      },
    );
  }

  /// Verificar token antes de mostrar notificación de sincronización
  Widget _buildSyncNotificationWithTokenCheck(SyncService syncService,
      int pendingCount, int failedCount, int totalPending) {
    return FutureBuilder<String?>(
      future: SharedPreferences.getInstance()
          .then((prefs) => prefs.getString('access_token')),
      builder: (context, snapshot) {
        final hasToken = snapshot.data?.isNotEmpty ?? false;

        if (!hasToken) {
          return _buildLoginRequiredNotification(totalPending);
        }

        return _buildPendingSyncNotification(
            syncService, pendingCount, failedCount);
      },
    );
  }

  /// Estado offline
  Widget _buildOfflineStatus(ConnectivityService connectivity) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off, color: Colors.grey, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).offlineModeTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context).offlineModeDescription,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Notificación de login requerido
  Widget _buildLoginRequiredNotification(int totalPending) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.withValues(alpha: 0.1),
            Colors.orange.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.login, color: Colors.orange, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).loginRequiredTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)
                          .loginRequiredMessage(totalPending),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                _showLoginDialog();
              },
              icon: const Icon(Icons.logout),
              label: Text(AppLocalizations.of(context).logoutAndLoginButton),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Notificación de registros pendientes
  Widget _buildPendingSyncNotification(
      SyncService syncService, int pendingCount, int failedCount) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            failedCount > 0
                ? Colors.red.withValues(alpha: 0.1)
                : Colors.blue.withValues(alpha: 0.1),
            failedCount > 0
                ? Colors.red.withValues(alpha: 0.05)
                : Colors.blue.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: failedCount > 0
              ? Colors.red.withValues(alpha: 0.3)
              : Colors.blue.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                failedCount > 0 ? Icons.sync_problem : Icons.cloud_sync,
                color: failedCount > 0 ? Colors.red : Colors.blue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      failedCount > 0
                          ? AppLocalizations.of(context).syncErrorTitle
                          : AppLocalizations.of(context).pendingSyncTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: failedCount > 0 ? Colors.red : Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      failedCount > 0
                          ? AppLocalizations.of(context)
                              .syncErrorMessage(failedCount, pendingCount)
                          : AppLocalizations.of(context)
                              .pendingSyncMessage(pendingCount),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: syncService.status == SyncStatus.syncing
                      ? null
                      : () async {
                          await syncService.forcSync();
                        },
                  icon: syncService.status == SyncStatus.syncing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.sync),
                  label: Text(
                    syncService.status == SyncStatus.syncing
                        ? AppLocalizations.of(context).synchronizing
                        : AppLocalizations.of(context).syncNowButton,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: failedCount > 0 ? Colors.red : Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              if (failedCount > 0) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await syncService.retryFailedEntries();
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(AppLocalizations.of(context).retryButton),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      side: const BorderSide(color: Colors.orange),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// Mostrar diálogo para cerrar sesión
  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).logoutDialogTitle),
        content: Text(AppLocalizations.of(context).logoutDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).cancelButton),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(context).logoutDialogTitle,
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Cerrar sesión
  Future<void> _logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (mounted) {
        // Navegar a login screen - necesitarás importar la screen de login
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)
                  .logoutErrorMessage(e.toString()))),
        );
      }
    }
  }
}

class _DashboardTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? routeName; // opcional (fallback)
  final VoidCallback? onTap; // NUEVO

  const _DashboardTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.routeName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.colorScheme.surface;
    final primary = theme.colorScheme.primary;
    final textTheme = theme.textTheme;
    final tap = onTap ??
        (routeName != null
            ? () => Navigator.of(context).pushReplacementNamed(routeName!)
            : null);

    return InkWell(
      onTap: tap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: kElevationToShadow[1],
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withOpacity(0.35),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: theme.colorScheme.onSurface),
              const SizedBox(height: 12),
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              // línea acento bajo el título, como en tu imagen
              Container(
                  width: 28,
                  height: 3,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(2),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
