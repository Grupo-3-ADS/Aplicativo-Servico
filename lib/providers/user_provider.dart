import 'package:flutter/material.dart';
import 'package:services/models/user.dart';
import 'package:services/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? get user => _authService.currentUser;

  Future<void> login(String username, String password) async {
    await _authService.login(username, password);
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }
}
