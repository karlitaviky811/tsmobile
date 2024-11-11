import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../widgets/index.dart';

class LoginScreen extends StatelessWidget {
  static const String route = 'login-route';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

      final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        width: screenWidth,
        child: DecoratedBox(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/daki-min-image.png")
                ),
            ),
            child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      top: 90,
                      left: 83,
                      child: Container(
                        width: 209,
                        height: 148,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/daki-min-image"),
                               fit: BoxFit.contain),
                        ),
                        child: null,
                      ),
                    ),
                    const Positioned(
                      bottom: 51,
                      left: 32,
                      right: 32,
                      child: ContainerButtons(),
                    )
                  ],
                ))),
      ),
    );
  }
}

class ContainerButtons extends StatelessWidget {
  const ContainerButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;

    return SizedBox(
        width: width,
        height: 300,
        child: Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomElevatedButton(
                color: Color(0xff1c2648),
                child: Text(
                  'Iniciar sesión',
                  style: AppStyle.txtPoppinsSemiBold18White,
                ),
              ),
              const SizedBox(height: 10),
              CustomElevatedButton(
                color: Colors.white.withOpacity(0.2),
                child: Text(
                  'Registrarme',
                  style: AppStyle.txtPoppinsSemiBold18White,
                ),
              ),
            ],
          ),
        ));
  }
}
