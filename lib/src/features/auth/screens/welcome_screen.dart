import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/features/main/screens/tabs_page.dart';
import 'package:tsmobile/src/providers/login_form_provider.dart';
import 'package:tsmobile/src/services/auth_service.dart';
import 'package:tsmobile/src/ui/input_decoration.dart';
import 'package:geolocator/geolocator.dart';
import '../../../widgets/index.dart';

class WelcomeScreen extends StatelessWidget {
  static const String route = 'welcome-route';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackgorund(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 280,
              ),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              /*const Text('Crear una nueva cuenta',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),*/
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    final authService = AuthService();

    Future<bool> _signIn() async {
      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token');
        await prefs.clear();

        final response = await authService.signIn(
          loginForm.email,
          loginForm.password,
        );
        print('Login successful:');
        return true;
      } catch (e) {
        print('Login failed: $e');
        return false;
      }
    }

    return Container(
      height: 300,
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        //Mantener la referencia al key
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'john.doe@gmail.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email,
              ),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                RegExp regExp = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El correo no es correcto';
              },
            ),
            const SizedBox(height: 30),
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                bool isPasswordVisible = false;
                return TextFormField(
                  autocorrect: false,
                  obscureText: !isPasswordVisible,
                  keyboardType: TextInputType.text,
                  decoration: InputDecorations.authInputDecoration(
                    hintText: '*****',
                    labelText: 'Contraseña',
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  onChanged: (value) => loginForm.password = value,
                  validator: (value) {
                    if (value != null && value.length >= 6) return null;
                    return 'La contraseña debe ser al menos de 6 caracteres';
                  },
                );
              },
            ),
            const SizedBox(height: 60),
            MaterialButton(
              onPressed: () async {
                if (loginForm.isValidForm()) {
                  bool success = await _signIn();
                  if (success) {
                    
                    Navigator.pushReplacementNamed(context, TabsPage.route);
                  } else {
                    Fluttertoast.showToast(
                      msg: "Error de autenticación",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledColor: Colors.grey,
              elevation: 0,
              color: const Color(0xffffdc00),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 15,
                ),
                child: const Text(
                  'Ingresar',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                print(
                    'Ubicación actual: ${position.latitude}, ${position.longitude}');
                // Aquí puedes enviar la ubicación al servidor o hacer lo que necesites con ella
              },
            ),
          ],
        );
      },
    );
  }
}
