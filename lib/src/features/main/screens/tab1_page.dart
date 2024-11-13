import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/features/main/screens/profile_user.dart';
import 'package:tsmobile/src/features/main/screens/reservation_screen.dart';
import 'package:tsmobile/src/features/main/screens/reservations_screen.dart';
import 'package:tsmobile/src/features/main/screens/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:tsmobile/src/features/main/screens/ticket_accepted_progress.dart';
import '../../../widgets/index.dart';

class HomeScreen extends StatefulWidget {
  static const String route = 'main-tabs-route';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: Colors.white, // Cambiar color aquí
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.bottomRight,
                  stops: [
                    0.1,
                    1.0,
                  ],
                  colors: [
                    Color(0xff051937),
                    Color(0XFF131314),
                  ],
                ),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                      Navigator.push( context, MaterialPageRoute(builder: (context) => const ProfileUser()), );
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Search'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 23, top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Hola Andrea!', style: AppStyle.txtPoppinsSemiBold20Black),
                const SizedBox(height: 31),
                Text(
                  'Servicios',
                  style: AppStyle.txtPoppinsMedium18Black,
                ),
                const SizedBox(height: 16),
                const _ListCourt(),
                const SizedBox(height: 40),
                Text(
                  'Servicios programados',
                  style: AppStyle.txtPoppinsMedium18Black,
                ),
                const SizedBox(height: 20),
                const _ListScheduleReservationItems(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ListCourt extends StatelessWidget {
  const _ListCourt({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          CardPreviewCourt(
            name: 'Nuevos',
            type: '',
            rainyPercentage: '30',
            image: 'assets/images/court1.png',
            onTap: () {
              Navigator.pushNamed(context, TicketAcceptedProgressDetailPage.route);
            },
          ),
          const SizedBox(width: 20),
          CardPreviewCourt(
            name: 'En proceso',
            type: '',
            rainyPercentage: '10',
            image: 'assets/images/court1.png',
            onTap: () {
              Navigator.pushNamed(context, ReservationScreen.route);
            },
          ),
          const SizedBox(width: 20),
          CardPreviewCourt(
            name: 'Histórico',
            type: '',
            rainyPercentage: '15',
            image: 'assets/images/court1.png',
            onTap: () {
              Navigator.pushNamed(context, ReservationScreen.route);
            },
          ),
        ],
      ),
    );
  }
}

class _ListScheduleReservationItems extends StatelessWidget {
  const _ListScheduleReservationItems();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.separated(
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ReservationsScreenCLient()),
                )
              },
              child: Container(
                  padding: const EdgeInsets.only(top: 13, left: 19),
                  width: double.infinity,
                  height: 180,
                  color: const Color(0xffF4F7FC),
                  child: const ReservationItem()),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8)),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.elevation = 2.0,
  });
  final Widget? title;
  final Widget? leading;
  final double elevation;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.bottomRight,
            stops: [
              0.1,
              1.0,
            ],
            colors: [
              Color(0xff051937),
              Color(0XFF131314),
            ],
          ),
        ),
        child: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: false,
          leading: leading,
          elevation: 0.0,
          toolbarHeight: 64,
          title: title,
          backgroundColor: Colors.transparent,
          actions: const [
            Icon(
              Icons.notifications,
              size: 30,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
