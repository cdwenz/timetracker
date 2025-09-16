import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';

import '../widgets/custom_drawer.dart';
import '../widgets/big_action_button.dart';
import '../widgets/offline_status_widget.dart';
import '../services/sync_service.dart';
import '../services/connectivity_service.dart';
import './tracking_steps_screens/step_01_screen.dart';
import './login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _username;
  String? _role;


  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkPendingSync();
  }

  void _checkPendingSync() async {
    // Forzar actualización de estadísticas al cargar la pantalla
    final syncService = context.read<SyncService>();
    await syncService.updateSyncStats();
  }

  /// Verificar si hay un token de autenticación válido
  Future<bool> _hasValidToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Construir notificación con verificación de token
  Widget _buildSyncNotificationWithTokenCheck(SyncService syncService, int pendingCount, int failedCount, int totalPending) {
    return FutureBuilder<bool>(
      future: _hasValidToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text(AppLocalizations.of(context).verifyingAuthStatus),
              ],
            ),
          );
        }
        
        final hasToken = snapshot.data ?? false;
        
        if (!hasToken) {
          // No hay token válido - mostrar mensaje de login
          return _buildLoginRequiredNotification(totalPending);
        } else {
          // Hay token válido - mostrar botones de sincronización
          return _buildPendingSyncNotification(syncService, pendingCount, failedCount);
        }
      },
    );
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('name') ?? AppLocalizations.of(context).defaultUserName;
      _role = prefs.getString('role') ?? AppLocalizations.of(context).guestRole;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).appTitle),
        actions: [
          const OfflineStatusWidget(compact: true),
          const SizedBox(width: 16),
        ],
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Notificación de sincronización (incluye estado offline y login)
            _buildSyncNotification(),
            const SizedBox(height: 20),
            
            // Contenido principal
            Text(
              AppLocalizations.of(context).homeGreeting(_username ?? ''),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            BigActionButton(
              text: AppLocalizations.of(context).startTrackingButton,
              icon: Icons.fast_forward_sharp,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const StepOneScreen(),
                  ),
                );
              },
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
          return _buildSyncNotificationWithTokenCheck(syncService, pendingCount, failedCount, totalPending);
        }
        
        // Caso 3: Todo sincronizado - no mostrar nada
        return const SizedBox.shrink();
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
                  style: TextStyle(
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context).loginRequiredMessage(totalPending),
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
  Widget _buildPendingSyncNotification(SyncService syncService, int pendingCount, int failedCount) {
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
                        ? AppLocalizations.of(context).syncErrorMessage(failedCount, pendingCount)
                        : AppLocalizations.of(context).pendingSyncMessage(pendingCount),
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
        content: Text(
          AppLocalizations.of(context).logoutDialogMessage
        ),
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
            child: Text(AppLocalizations.of(context).logoutDialogTitle, style: const TextStyle(color: Colors.white)),
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
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).logoutErrorMessage(e.toString()))),
        );
      }
    }
  }
}
