import 'package:flutter/material.dart';
import '../lib/viewmodels/poliza_viewmodel.dart';

class FakeLoginViewModel extends ChangeNotifier {
  String? _user;
  bool login(String user, String pass) {
    if (user == 'demo' && pass == '1234') {
      _user = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool get isLoggedIn => _user != null;
}

class FakePolizaViewModel extends PolizaViewModel {
  @override
  Future<void> calcularPoliza() async {
    // cálculo local simple
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
