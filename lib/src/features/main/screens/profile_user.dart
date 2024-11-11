import 'package:flutter/material.dart';
import 'package:tsmobile/src/features/main/screens/side_menu.dart';
import 'package:tsmobile/src/features/main/screens/tab1_page.dart';
import 'package:tsmobile/src/features/main/screens/tabs_page.dart';
import 'package:tsmobile/src/features/main/widgets/collapsable_list.dart';

class ProfileUser extends StatelessWidget {
  const ProfileUser({Key? key}) : super(key: key);

  static const String route = 'profile-ticket-route';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Perfil'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, HomeScreen.route);
              }),
        ),
        body: const CollapsibleList());
  }
}
