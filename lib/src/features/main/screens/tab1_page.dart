import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/features/main/screens/profile_user.dart';
import 'package:tsmobile/src/features/main/screens/reservation_screen.dart';
import 'package:tsmobile/src/features/main/screens/reservations_screen.dart';
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
        backgroundColor: Color(0xffF3F5FD),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              ListTile(
                leading: const Icon(Icons.account_circle_rounded),
                title: const Text('Perfil'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileUser()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Calificaciones'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileUser()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configuración'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(
                height: 30,
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Salir'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 23, top: 12),
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Hola Andrea!',
                          style: AppStyle.txtPoppinsSemiBold20Black),
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
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
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
              Navigator.pushNamed(
                  context, TicketAcceptedProgressDetailPage.route);
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
              child: const ReservationItem(),
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

Widget _buildGradientCard({
  required String title,
  required IconData icon,
  required List<Color> gradientColors,
  required int count,
  required String imageUrl,
}) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: InkWell(
      onTap: () {
        // Acción al presionar la tarjeta
      },
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(imageUrl, width: 100, height: 100),
            const SizedBox(height: 10),
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

