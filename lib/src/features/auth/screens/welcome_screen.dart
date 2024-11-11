import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/features/auth/screens/index.dart';
import 'package:tsmobile/src/features/main/screens/tabs_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


import '../../../widgets/index.dart';

class WelcomeScreen extends StatelessWidget {
  static const String route = 'welcome-route';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            
            children: [
              Container(
                width: width,
                height: 200,
                margin: EdgeInsets.all(55),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    
                      image: AssetImage('assets/images/daki-login.png'),
                       fit: BoxFit.contain),
                ),
                child: null,
              ),
              Container(
                padding: EdgeInsets.only(left: 33),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Iniciar ',
                          style: AppStyle.txtPoppinsSemiBold24Black.copyWith(
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xff346BC3),
                            decorationThickness: 2,
                          ),
                        ),
                        TextSpan(
                            text: 'Sesión',
                            style: AppStyle.txtPoppinsSemiBold24Black)
                      ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 46),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 33),
                width: double.infinity,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Email'),
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 26),
                    TextFormField(
                      decoration: const InputDecoration(
                          label: Text('contraseña'),
                          prefixIcon: Icon(Icons.lock_outlined),
                          suffixIcon: Icon(Icons.visibility_outlined)),
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.all(0),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: false,
                      onChanged: (value) {},
                      title: Text('Recordar contraseña',
                          style: AppStyle.txtPoppinsRegular12Black),
                    ),
                    Text(
                      '¿Olvidaste tu contraseña?',
                      style: AppStyle.txtPoppinsRegular14Blue,
                    ),
                    const SizedBox(height: 40),
                    CustomElevatedButton(
                      onChange: () {
                        Navigator.pushNamed(context, TabsPage.route);
                      },
                      color: Color(0xff1c2648),
                      child: Text(
                        'Iniciar sesión',
                        style: AppStyle.txtPoppinsSemiBold18White,
                      ),
                    ),
                    const SizedBox(height: 64),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: '¿Aun no tienes cuenta?',
                          style: AppStyle.txtPoppinsRegular14Black),
                      TextSpan(
                          text: ' Regístrate',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(
                                  context, RegisterScreen.route);
                              // Single tapped.
                            },
                          style: AppStyle.txtPoppinsRegular14Blue)
                    ]))
                  ],
                ),
              )
            ],
          )),
    );
  }
}
