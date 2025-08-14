import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginViewModel extends ChangeNotifier {
  String _username = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  // Getters
  String get username => _username;
  String get password => _password;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  set errorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  // Setters
  set username(String value) {
    _username = value;
    notifyListeners();
  }

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  set isAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }

  // Método de login
  Future<bool> login() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Para desarrollo, puedes usar credenciales hardcodeadas
      if (_username == 'demo' && _password == '1234') {
        await Future.delayed(const Duration(seconds: 1)); // Simular llamada API
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      // Código real para API (descomenta cuando tengas el backend)

      final response = await http.post(
        Uri.parse('http://localhost:9090/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': _username, 'password': _password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Guardar token si es necesario
        // await saveToken(data['token']);
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Credenciales inválidas';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Si no coincide con demo
    } catch (e) {
      _errorMessage = 'Error de conexión';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Método de logout
  void logout() {
    _username = '';
    _password = '';
    _isAuthenticated = false;
    _errorMessage = null;
    notifyListeners();
  }

  // Limpiar errores
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
