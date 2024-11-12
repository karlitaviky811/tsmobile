import 'package:flutter/material.dart';
import 'package:tsmobile/src/features/main/screens/profile_user.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _DrawerHeader(),
          ListTile(
            leading: const Icon(Icons.pages_outlined),
            title: const Text('Home'),
            onTap: (){
              //Navigator.pop(context);
              Navigator.push( context, MaterialPageRoute(builder: (context) => const ProfileUser()), );
            },
          ),
            ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text('People'),
            onTap: (){
              
            },
          ),
            ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: (){
              
            },
          )
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Container(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/img_iniciodesesin.png'),
              fit: BoxFit.fill)),
    );
  }
}
