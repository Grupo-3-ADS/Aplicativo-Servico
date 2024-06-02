import 'package:flutter/material.dart';
import 'package:services/models/user.dart';

class AuthService {
  User? currentUser;

  Future<bool> login(String username, String password) async {
    // Simulação de login
    await Future.delayed(Duration(seconds: 2));
    currentUser = User(
        id: '1',
        name: 'Tiago Huf',
        userType: UserType
            .client); // Mudar para UserType.provider conforme necessário
    return true;
  }

  Future<void> logout() async {
    currentUser = null;
  }
}
