import 'package:flutter/material.dart';
import 'package:frontend_consumo_recursos/viewmodels/poliza_viewmodel.dart';
import 'package:frontend_consumo_recursos/viewmodels/login_viewmodel.dart';

class FakeLoginViewModel extends LoginViewModel {
  @override
  Future<bool> login() async {
    if (username == 'demo' && password == '1234') {
      isAuthenticated = true;
      notifyListeners();
      return true;
    }
    errorMessage = 'Credenciales inválidas';
    notifyListeners();
    return false;
  }
}

class FakePolizaViewModel extends PolizaViewModel {
  @override
  Future<void> calcularPoliza() async {
    // Asegurarse de que tenemos valores válidos
    if (valorAlquiler == 0) return;

    costoTotal =
        valorAlquiler * 0.05 +
        (modeloAuto == 'A'
            ? 100
            : modeloAuto == 'B'
            ? 200
            : 300) +
        (edadPropietario == '18-23'
            ? 150
            : edadPropietario == '23-55'
            ? 75
            : 120) +
        accidentes * 50;

    await Future.delayed(const Duration(milliseconds: 200)); // simular red
    notifyListeners();
  }
}
