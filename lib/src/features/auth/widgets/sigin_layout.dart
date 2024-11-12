import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SiginLayoutScreen extends StatelessWidget {
  final Widget child;
  final Widget title;

  const SiginLayoutScreen(
      {super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Column(children: [
      Container(
          width: width,
          height: 300,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover),
          )),
      const SizedBox(height: 40),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 33),
        child: Column(
          children: [title, const SizedBox(height: 46), child],
        ),
      )
    ]);
  }
}
