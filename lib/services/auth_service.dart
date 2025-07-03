// import 'package:firebase_auth/firebase_auth.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Método de Login
//   Future<UserCredential?> signIn(String email, String password) async {
//     try {
//       return await _auth.signInWithEmailAndPassword(
//         email: email, 
//         password: password
//       );
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }
//   // Método de Registro
//   Future<UserCredential?> register(String email, String password) async {
//     try {
//       return await _auth.createUserWithEmailAndPassword(
//         email: email, 
//         password: password
//       );
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   // Cerrar sesión
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }
// }