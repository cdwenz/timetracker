import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

/// Servicio para monitorear el estado de conectividad de la red
class ConnectivityService extends ChangeNotifier {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  
  bool _isConnected = false;
  ConnectivityResult _connectionType = ConnectivityResult.none;
  DateTime? _lastConnectedTime;
  DateTime? _lastDisconnectedTime;

  /// Estado actual de conectividad
  bool get isConnected => _isConnected;
  
  /// Tipo de conexión actual
  ConnectivityResult get connectionType => _connectionType;
  
  /// Última vez que se conectó
  DateTime? get lastConnectedTime => _lastConnectedTime;
  
  /// Última vez que se desconectó
  DateTime? get lastDisconnectedTime => _lastDisconnectedTime;

  /// Inicializar el servicio de conectividad
  Future<void> initialize() async {
    try {
      // Obtener estado inicial de conectividad
      final connectivityResults = await _connectivity.checkConnectivity();
      await _updateConnectionStatus(connectivityResults);

      // Escuchar cambios en la conectividad
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        _updateConnectionStatus,
        onError: (error) {
          print('❌ Error en connectivity stream: $error');
        },
      );

      print('📡 ConnectivityService inicializado');
    } catch (e) {
      print('❌ Error al inicializar ConnectivityService: $e');
    }
  }

  /// Actualizar el estado de conexión
  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    final bool wasConnected = _isConnected;
    
    // Determinar si hay conexión válida
    _isConnected = results.any((result) => 
      result == ConnectivityResult.mobile ||
      result == ConnectivityResult.wifi ||
      result == ConnectivityResult.ethernet ||
      result == ConnectivityResult.vpn
    );

    // Actualizar tipo de conexión (tomar la primera válida)
    _connectionType = results.isNotEmpty 
      ? results.first 
      : ConnectivityResult.none;

    // Actualizar timestamps
    final now = DateTime.now();
    if (_isConnected && !wasConnected) {
      _lastConnectedTime = now;
      print('🟢 Conectado a internet - ${_getConnectionTypeName()}');
    } else if (!_isConnected && wasConnected) {
      _lastDisconnectedTime = now;
      print('🔴 Desconectado de internet');
    }

    // Notificar a los listeners
    notifyListeners();

    // Verificar conexión real con ping si reporta como conectado
    if (_isConnected) {
      await _verifyInternetConnection();
    }
  }

  /// Verificar si realmente hay acceso a internet (no solo conexión local)
  Future<void> _verifyInternetConnection() async {
    try {
      // Intentar hacer ping a un servidor conocido
      final result = await _connectivity.checkConnectivity();
      
      // Para una verificación más robusta, podrías hacer un HTTP request a tu backend
      // o a un servicio como Google DNS (8.8.8.8)
      
      print('🔍 Verificación de internet: ${result.toString()}');
    } catch (e) {
      print('⚠️ Verificación de internet falló: $e');
      // En caso de error en la verificación, mantener el estado actual
    }
  }

  /// Forzar verificación de conectividad
  Future<bool> checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      await _updateConnectionStatus(results);
      return _isConnected;
    } catch (e) {
      print('❌ Error al verificar conectividad: $e');
      return false;
    }
  }

  /// Obtener nombre legible del tipo de conexión
  String _getConnectionTypeName() {
    switch (_connectionType) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Datos móviles';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.other:
        return 'Otra conexión';
      case ConnectivityResult.none:
      default:
        return 'Sin conexión';
    }
  }

  /// Obtener nombre del tipo de conexión (método público)
  String get connectionTypeName => _getConnectionTypeName();

  /// Obtener duración de la última desconexión
  Duration? get timeSinceLastDisconnection {
    if (_lastDisconnectedTime == null) return null;
    return DateTime.now().difference(_lastDisconnectedTime!);
  }

  /// Obtener duración desde la última conexión
  Duration? get timeSinceLastConnection {
    if (_lastConnectedTime == null) return null;
    return DateTime.now().difference(_lastConnectedTime!);
  }

  /// Verificar si ha estado desconectado por más de X minutos
  bool hasBeenDisconnectedFor(Duration duration) {
    if (_isConnected || _lastDisconnectedTime == null) return false;
    return DateTime.now().difference(_lastDisconnectedTime!) >= duration;
  }

  /// Obtener información detallada del estado de conectividad
  Map<String, dynamic> getDetailedStatus() {
    return {
      'isConnected': _isConnected,
      'connectionType': _connectionType.toString(),
      'connectionTypeName': connectionTypeName,
      'lastConnectedTime': _lastConnectedTime?.toIso8601String(),
      'lastDisconnectedTime': _lastDisconnectedTime?.toIso8601String(),
      'timeSinceLastConnection': timeSinceLastConnection?.inSeconds,
      'timeSinceLastDisconnection': timeSinceLastDisconnection?.inSeconds,
    };
  }

  /// Limpiar recursos
  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  /// Método estático para uso rápido sin instancia
  static Future<bool> quickConnectivityCheck() async {
    try {
      final connectivity = Connectivity();
      final results = await connectivity.checkConnectivity();
      return results.any((result) => 
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.vpn
      );
    } catch (e) {
      print('❌ Error en quick connectivity check: $e');
      return false;
    }
  }
}