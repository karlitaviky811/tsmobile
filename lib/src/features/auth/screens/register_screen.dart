import 'package:tsmobile/src/features/auth/widgets/sigin_layout.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app.styles.dart';
import '../../../widgets/index.dart';

class RegisterScreen extends StatelessWidget {
  static const String route = 'register-route';

  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          SiginLayoutScreen(
            title: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Registrar',
                  style: AppStyle.txtPoppinsSemiBold24Black.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xff346BC3),
                    decorationThickness: 2,
                  ),
                ),
              ]),
            ),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    label: Text('Nombre y apellido'),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 37),
                TextFormField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    label: Text('email'),
                    prefixIcon: Icon(Icons.lock_outlined),
                  ),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 37),
                TextFormField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    label: Text('Teléfono'),
                    prefixIcon: Icon(Icons.smartphone_outlined),
                  ),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 37),
                TextFormField(
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      label: Text('contraseña'),
                      prefixIcon: Icon(Icons.lock_outlined),
                      suffixIcon: Icon(Icons.visibility_outlined)),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 37),
                TextFormField(
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      label: Text('confirmar contraseña'),
                      prefixIcon: Icon(Icons.lock_outlined),
                      suffixIcon: Icon(Icons.visibility_outlined)),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 40),
                CustomElevatedButton(
                  color: const Color(0xff82BC00),
                  child: Text(
                    'Iniciar sesión',
                    style: AppStyle.txtPoppinsSemiBold18White,
                  ),
                ),
                const SizedBox(height: 38),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: '¿Aun no tienes cuenta?',
                      style: AppStyle.txtPoppinsRegular14Black),
                  TextSpan(
                      text: ' Regístrate',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, RegisterScreen.route);
                          // Single tapped.
                        },
                      style: AppStyle.txtPoppinsRegular14Blue)
                ]))
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
