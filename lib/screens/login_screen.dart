import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ihadi_time_tracker/screens/home_screen.dart';
import 'package:ihadi_time_tracker/services/auth_service.dart';
import 'package:ihadi_time_tracker/screens/register_screen.dart';
import 'package:provider/provider.dart';
import '../../models/tracking_data.dart';
import '../../services/connectivity_service.dart';
import '../../widgets/offline_status_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isOffline = false;
  bool _hasOfflineLogin = false;

  String? _error;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _checkOfflineLogin();
  }

  void _checkConnectivity() async {
    final isConnected = await ConnectivityService.quickConnectivityCheck();
    if (mounted) {
      setState(() {
        _isOffline = !isConnected;
      });
    }
  }

  void _checkOfflineLogin() async {
    final hasOffline = await AuthService.hasValidOfflineLogin();
    if (mounted) {
      setState(() {
        _hasOfflineLogin = hasOffline;
      });
    }
  }

  void _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final success = await AuthService.login(username, password);

    if (!mounted) return; // <- Primera validación después del await

    if (success) {
      final prefs = await SharedPreferences.getInstance();

      if (!mounted)
        return; // <- Segunda validación (por si tarda mucho en abrir prefs)

      final userName = prefs.getString('name');
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', username);

      if (!mounted)
        return; // <- Tercera validación antes de usar Provider y Navigator

      Provider.of<TrackingData>(context, listen: false)
          .setPersonName(userName ?? '');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      if (!mounted) return;
      setState(() {
        if (_isOffline && !_hasOfflineLogin) {
          _error = 'Sin conexión. Necesitas hacer login online primero para usar la app offline.';
        } else {
          _error = 'Credenciales incorrectas';
        }
      });
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Indicador de estado offline/online
              if (_isOffline) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _hasOfflineLogin ? Colors.orange.shade100 : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _hasOfflineLogin ? Colors.orange : Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _hasOfflineLogin ? Icons.wifi_off : Icons.signal_wifi_off,
                        color: _hasOfflineLogin ? Colors.orange : Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _hasOfflineLogin 
                          ? 'Modo offline - Usando credenciales guardadas'
                          : 'Sin conexión - Se requiere internet para primer login',
                        style: TextStyle(
                          color: _hasOfflineLogin ? Colors.orange.shade800 : Colors.red.shade800,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              
              Image.asset('assets/ihadi.png', height: 120),
              const SizedBox(height: 24),
              const Text("Iniciar sesión",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  suffixIcon: IconButton(
                    tooltip: _obscurePassword ? 'Mostrar' : 'Ocultar',
                    icon: Icon(_obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFC6502),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 48, vertical: 14),
                      ),
                      child: const Text("Entrar", style:TextStyle(color: Colors.black)),
                    ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: const Text(
                  '¿No tenés cuenta? Registrate',
                  style: TextStyle(color: Color(0xFFFC6502)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
