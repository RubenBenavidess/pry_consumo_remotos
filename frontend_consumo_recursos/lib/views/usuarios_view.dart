import 'package:flutter/material.dart';

class UsuariosView extends StatelessWidget {
  const UsuariosView({super.key});

  @override
  Widget build(BuildContext context) {
    final demoUsers = ['Alice', 'Bob', 'Charlie'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        key: const Key('usuariosList'),
        itemCount: demoUsers.length,
        itemBuilder: (ctx, i) => ListTile(
          key: Key('usuarioItem_$i'),
          leading: const Icon(Icons.person),
          title: Text(demoUsers[i]),
        ),
      ),
    );
  }
}
