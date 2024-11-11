import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/features/main/screens/calendar_services.dart';
import 'package:tsmobile/src/features/main/screens/reservation_screen.dart';
import 'package:tsmobile/src/features/main/screens/reservations_screen.dart';
import 'package:tsmobile/src/features/main/screens/side_menu.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/widgets/CardPreviewCourt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../core/models/reservation.dart';
import '../../../widgets/index.dart';

class HomeScreen extends StatefulWidget {
 static const String route = 'main-route';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: Text(
            'Home',
            style: TextStyle(color: Colors.white),
          ),
        ),
        drawer: SideMenu(),
        body: SingleChildScrollView(
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
        ));
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
              Navigator.pushNamed(context, ReservationScreen.route);
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
  const _ListScheduleReservationItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.separated(
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (context, index) {
            return Container(
                padding: EdgeInsets.only(top: 13, left: 19),
                width: double.infinity,
                height: 180,
                color: Color(0xffF4F7FC),
                child: ReservationItem());
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8)),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.title,
    this.leading,
    this.actions,
    this.elevation = 2.0,
  }) : super(key: key);
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
              0.6,
              1.0,
            ],
            colors: [
              Color(0xff1c2648),
              Color(0XFF283F58),
              Color(0XFF06274D),
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
          actions: [
            const Icon(
              Icons.thunderstorm_outlined,
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
