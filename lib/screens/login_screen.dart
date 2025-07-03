// import 'package:flutter/material.dart';
// import '../services/auth_service.dart';
// import 'home_screen.dart';
// import 'register_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final AuthService _authService = AuthService();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;

//   void _login() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       try {
//         final result = await _authService.signIn(
//           _emailController.text.trim(), 
//           _passwordController.text.trim()
//         );

//         if (result != null) {
//           // ignore: use_build_context_synchronously
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => const HomeScreen())
//           );
//         } else {
//           // ignore: use_build_context_synchronously
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Error de inicio de sesión'))
//           );
//         }
//       } catch (e) {
//         // ignore: use_build_context_synchronously
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: ${e.toString()}'))
//         );
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const FlutterLogo(size: 100),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Iniciar Sesión',
//                   style: TextStyle(
//                     fontSize: 24, 
//                     fontWeight: FontWeight.bold
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: const InputDecoration(
//                     labelText: 'Correo Electrónico',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.email),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Por favor ingresa tu correo';
//                     }
//                     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                       return 'Correo electrónico inválido';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 15),
//                 TextFormField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: const InputDecoration(
//                     labelText: 'Contraseña',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.lock),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Por favor ingresa tu contraseña';
//                     }
//                     if (value.length < 6) {
//                       return 'La contraseña debe tener al menos 6 caracteres';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 _isLoading 
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                       onPressed: _login,
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: const Size(double.infinity, 50),
//                       ),
//                       child: const Text('Iniciar Sesión'),
//                     ),
//                 const SizedBox(height: 15),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) => RegisterScreen())
//                     );
//                   },
//                   child: const Text('¿No tienes cuenta? Regístrate'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }