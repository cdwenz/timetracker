import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _token;
  String? _userId;

  String? get token => _token;
  String? get userId => _userId;

  bool get isLoggedIn => _token != null;

  void login({required String token, required String userId}) {
    _token = token;
    _userId = userId;
    notifyListeners();
  }

  void logout() {
    _token = null;
    _userId = null;
    notifyListeners();
  }
}
