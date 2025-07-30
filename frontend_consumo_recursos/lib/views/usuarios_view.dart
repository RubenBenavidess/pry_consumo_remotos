import 'package:flutter/material.dart';

class UsuariosView extends StatelessWidget {
  static const routeName = '/usuarios';
  const UsuariosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuarios", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text("Lista de Usuarios"),
      ),
    );
  }
}