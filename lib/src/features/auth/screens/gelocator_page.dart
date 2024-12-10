import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tsmobile/src/services/auth_service.dart';
// Tu servicio de autenticación

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _signIn() async {
    try {
      final response = await _authService.signIn(
        _emailController.text,
        _passwordController.text,
      );
      if (response != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        ).then((_) {
          _showLocationModal(context);
        });
      }
    } catch (e) {
      print('Login failed: $e');
    }
  }

  void _showLocationModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Actualizar Ubicación'),
          content: const Text('¿Deseas actualizar tu ubicación actual?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Actualizar'),
              onPressed: () async {
                Navigator.of(context).pop();
                Position position = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.high,
                );
                print('Ubicación actual: ${position.latitude}, ${position.longitude}');
                // Aquí puedes enviar la ubicación al servidor o hacer lo que necesites con ella
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _signIn,
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: LoginScreen(),
));
