import 'package:flutter/material.dart';
import 'package:frontend_consumo_recursos/views/poliza_view.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                key: const ValueKey('emailField'),
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter email';
                  final regex = RegExp(r"^[^@]+@[^@]+\\.[^@]+$");
                  if (!regex.hasMatch(value)) return 'Invalid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const ValueKey('passwordField'),
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter password';
                  if (value.length < 6) return 'Min 6 chars';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (viewModel.isLoading)
                const CircularProgressIndicator(key: ValueKey('loadingIndicator'))
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    key: const ValueKey('loginButton'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final success = await viewModel.login(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                        if (success) {
                          Navigator.pushReplacementNamed(context, PolizaView.routeName);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(viewModel.error ?? 'Error')),
                          );
                        }
                      }
                    },
                    child: const Text('Login'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}