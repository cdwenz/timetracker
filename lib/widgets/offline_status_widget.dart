import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/connectivity_service.dart';
import '../services/sync_service.dart';

/// Widget que muestra el estado de conectividad y sincronización
class OfflineStatusWidget extends StatelessWidget {
  final bool compact;
  final VoidCallback? onTap;

  const OfflineStatusWidget({
    super.key,
    this.compact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityService>(
      builder: (context, connectivityService, child) {
        return Consumer<SyncService>(
          builder: (context, syncService, child) {
            return InkWell(
              onTap: onTap ?? () => _showDetailedStatus(context, connectivityService, syncService),
              child: compact 
                ? _buildCompactWidget(context, connectivityService, syncService)
                : _buildFullWidget(context, connectivityService, syncService),
            );
          },
        );
      },
    );
  }

  /// Widget compacto para mostrar en AppBar
  Widget _buildCompactWidget(BuildContext context, ConnectivityService connectivity, SyncService sync) {
    final isOnline = connectivity.isConnected;
    final pendingCount = sync.pendingSyncCount;
    final failedCount = sync.failedSyncCount;
    
    IconData icon;
    Color color;
    
    if (!isOnline) {
      icon = Icons.cloud_off;
      color = Colors.grey;
    } else if (sync.status == SyncStatus.syncing) {
      icon = Icons.sync;
      color = Colors.orange;
    } else if (failedCount > 0) {
      icon = Icons.sync_problem;
      color = Colors.red;
    } else if (pendingCount > 0) {
      icon = Icons.cloud_sync;
      color = Colors.blue;
    } else {
      icon = Icons.cloud_done;
      color = Colors.green;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (sync.status == SyncStatus.syncing)
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: color,
            ),
          )
        else
          Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        if (pendingCount > 0 || failedCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: failedCount > 0 ? Colors.red : Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${pendingCount + failedCount}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  /// Widget completo con más información
  Widget _buildFullWidget(BuildContext context, ConnectivityService connectivity, SyncService sync) {
    final isOnline = connectivity.isConnected;
    final pendingCount = sync.pendingSyncCount;
    final failedCount = sync.failedSyncCount;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isOnline ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isOnline ? Icons.cloud_done : Icons.cloud_off,
                color: isOnline ? Colors.green : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isOnline ? 'Conectado (${connectivity.connectionTypeName})' : 'Sin conexión',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isOnline ? Colors.green : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildSyncStatus(context, sync),
          if (pendingCount > 0 || failedCount > 0) ...[
            const SizedBox(height: 8),
            _buildSyncCounts(pendingCount, failedCount),
          ],
        ],
      ),
    );
  }

  /// Construir estado de sincronización
  Widget _buildSyncStatus(BuildContext context, SyncService sync) {
    String statusText;
    Color statusColor;
    IconData statusIcon;

    switch (sync.status) {
      case SyncStatus.idle:
        statusText = 'Listo para sincronizar';
        statusColor = Colors.grey;
        statusIcon = Icons.sync;
        break;
      case SyncStatus.syncing:
        statusText = 'Sincronizando...';
        statusColor = Colors.orange;
        statusIcon = Icons.sync;
        break;
      case SyncStatus.success:
        statusText = 'Última sincronización exitosa';
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case SyncStatus.failed:
        statusText = 'Error en sincronización';
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      case SyncStatus.paused:
        statusText = 'Sincronización pausada';
        statusColor = Colors.orange;
        statusIcon = Icons.pause_circle;
        break;
    }

    return Row(
      children: [
        if (sync.status == SyncStatus.syncing)
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: statusColor,
            ),
          )
        else
          Icon(statusIcon, color: statusColor, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            statusText,
            style: TextStyle(
              fontSize: 12,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }

  /// Construir contadores de sincronización
  Widget _buildSyncCounts(int pendingCount, int failedCount) {
    return Row(
      children: [
        if (pendingCount > 0) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud_upload, size: 12, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  '$pendingCount pendientes',
                  style: const TextStyle(fontSize: 10, color: Colors.blue),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
        if (failedCount > 0) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 12, color: Colors.red),
                const SizedBox(width: 4),
                Text(
                  '$failedCount fallidos',
                  style: const TextStyle(fontSize: 10, color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  /// Mostrar estado detallado en un modal
  void _showDetailedStatus(BuildContext context, ConnectivityService connectivity, SyncService sync) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _DetailedStatusModal(connectivity: connectivity, sync: sync),
    );
  }
}

/// Modal con información detallada del estado
class _DetailedStatusModal extends StatelessWidget {
  final ConnectivityService connectivity;
  final SyncService sync;

  const _DetailedStatusModal({
    required this.connectivity,
    required this.sync,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estado de Sincronización',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          
          // Estado de conectividad
          _buildInfoCard(
            context,
            'Conectividad',
            [
              _InfoRow('Estado', connectivity.isConnected ? 'Conectado' : 'Desconectado'),
              _InfoRow('Tipo', connectivity.connectionTypeName),
              if (connectivity.lastConnectedTime != null)
                _InfoRow('Última conexión', _formatDateTime(connectivity.lastConnectedTime!)),
              if (connectivity.lastDisconnectedTime != null)
                _InfoRow('Última desconexión', _formatDateTime(connectivity.lastDisconnectedTime!)),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Estado de sincronización
          _buildInfoCard(
            context,
            'Sincronización',
            [
              _InfoRow('Estado', sync.status.toString().split('.').last),
              _InfoRow('Último mensaje', sync.lastSyncMessage),
              if (sync.lastSyncTime != null)
                _InfoRow('Última sincronización', _formatDateTime(sync.lastSyncTime!)),
              _InfoRow('Entradas pendientes', sync.pendingSyncCount.toString()),
              _InfoRow('Entradas fallidas', sync.failedSyncCount.toString()),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Botones de acción
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: sync.status == SyncStatus.syncing ? null : () async {
                    await sync.forcSync();
                  },
                  icon: const Icon(Icons.sync),
                  label: const Text('Sincronizar'),
                ),
              ),
              const SizedBox(width: 12),
              if (sync.failedSyncCount > 0)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await sync.retryFailedEntries();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, List<_InfoRow> rows) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...rows.map((row) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      '${row.label}:',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      row.value,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Hace unos segundos';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} minutos';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} horas';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}

class _InfoRow {
  final String label;
  final String value;

  _InfoRow(this.label, this.value);
}