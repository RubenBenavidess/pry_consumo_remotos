import 'package:flutter/material.dart';
import 'package:frontend_consumo_recursos/viewmodels/poliza_viewmodel.dart';
import 'package:frontend_consumo_recursos/views/poliza_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PolizaViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seguro App',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const PolizaView(),
    );
  }
}
