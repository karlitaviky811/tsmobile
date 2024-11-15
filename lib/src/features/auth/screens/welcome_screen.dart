import 'package:provider/provider.dart';
import 'package:tsmobile/src/features/main/screens/tabs_page.dart';
import 'package:flutter/material.dart';
import 'package:tsmobile/src/providers/login_form_provider.dart';
import 'package:tsmobile/src/ui/input_decoration.dart';

import '../../../widgets/index.dart';

class WelcomeScreen extends StatelessWidget {
  static const String route = 'welcome-route';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: AuthBackgorund(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const Text('Hoooolaaa'),
            const SizedBox(
              height: 280,
            ),
            CardContainer(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text('Login',
                      style: Theme.of(context).textTheme.headlineSmall),
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
      )),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

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
                      prefixIcon: Icons.alternate_email),
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
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  autocorrect: false,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: '*****',
                      labelText: 'Contraseña',
                      prefixIcon: Icons.lock_outline),
                  onChanged: (value) => loginForm.password = value,
                  validator: (value) {
                    if (value != null && value.length >= 6) return null;

                    return 'La contraseña debe ser al menos de 6 caracteres';
                  },
                ),
                const SizedBox(
                  height: 60,
                ),
                MaterialButton(
                  onPressed: () {
                    if (loginForm.isValidForm()) {
                      Navigator.pushReplacementNamed(context, TabsPage.route);
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  disabledColor: Colors.grey,
                  elevation: 0,
                  color: Color(0xffF4BC1C),
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 15),
                      child: const Text('Ingresar',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold))),
                )
              ],
            )));
  }
}
