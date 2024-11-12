import 'package:flutter/material.dart';

class AuthBackgorund extends StatelessWidget {
  final Widget child;

  const AuthBackgorund({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.blueAccent,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [const _PurpleBox(), _HeaderIcon(), child],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          margin: const EdgeInsets.only(top: 30),
          width: double.infinity,
          child:  Container(
                width: 130,
                height: 130,
                margin: EdgeInsets.all(55),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/daki-login.png'),
                      fit: BoxFit.contain),
                ),
                child: null,
              ),
    ));
  }
}

class _PurpleBox extends StatelessWidget {
  const _PurpleBox({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _purpleBackground(),
      child: const Stack(
        children: [
          Positioned(top: 90, left: 30, child: _Bubble()),
          Positioned(top: -40, left: -30, child: _Bubble()),
          Positioned(top: -50, right: -20, child: _Bubble()),
          Positioned(bottom: -50, left: 10, child: _Bubble()),
          Positioned(bottom: 120, right: 20, child: _Bubble()),
        ],
      ),
    );
  }

  BoxDecoration _purpleBackground() {
    return const BoxDecoration(
        gradient: LinearGradient(colors: [
      Color(0XFF06274D),
      Color(0XFF06274D),
    ]));
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );
  }
}
