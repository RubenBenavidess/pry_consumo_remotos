import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/login_view.dart';
import 'views/poliza_view.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/poliza_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => PolizaViewModel()),
        // Agrega aquí otros providers si los necesitas
      ],
      child: MaterialApp(
        initialRoute: LoginPage.routeName,
        routes: {
          LoginPage.routeName: (_) => const LoginPage(),
          PolizaView.routeName: (_) => const PolizaView(),
        },
      ),
    ),
  );
}