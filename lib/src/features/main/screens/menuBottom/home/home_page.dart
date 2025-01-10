import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/features/main/screens/location_card.dart';
import 'package:flutter/material.dart';
import 'package:tsmobile/src/features/main/screens/listTickets/list_tickets_page.dart';
import 'package:tsmobile/src/features/main/screens/notifications_screen.dart';
import 'package:tsmobile/src/features/main/screens/listTickets/ticket_accepted_progress.dart';
import 'package:tsmobile/src/models/ticket_model.dart';
import 'package:tsmobile/src/models/auth_model.dart';
import 'package:tsmobile/src/models/visit_model.dart';
import 'package:tsmobile/src/providers/user_provider.dart';
import 'package:tsmobile/src/widgets/home/card_preview_list.dart';
import '../../../../../widgets/index.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  static const String route = 'main-tabs-route';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;
  String? userEmail;
  User? user;
  @override
  void initState() {
    super.initState();
    main();
  }

  void main() async {
    final userService = UserProvider();
    Future<void> fetchedUser = userService.obatinUserData();
    await dotenv.load(fileName: ".env");
    await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    fetchedUser.then((_) {
      setState(() {
        user = userService.user;
      });
      final oneSignalAppId = dotenv.env['APP_ID'];
      WidgetsFlutterBinding.ensureInitialized();

      OneSignal.initialize(oneSignalAppId as String);
      final String userTag = userService.user!.id.toString();

      if ((OneSignal.User.pushSubscription.id == null)) {
        OneSignal.Notifications.requestPermission(true);
        print('epa $userTag');

        OneSignal.User.addAlias('external_id', "technical-$userTag");
        OneSignal.User.addTagWithKey('external_id', "technical-$userTag");
      }

      OneSignal.login("technical-$userTag");
      OneSignal.Notifications.addForegroundWillDisplayListener((event) {
        print(
            'NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');

        event.preventDefault();
        event.notification.display();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return user == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            key: _scaffoldKey,
            appBar: CustomAppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationListScreen(),
                        ));
                  },
                ),
              ],
              leading: IconButton(
                icon:
                    Image.asset('assets/images/android-chrome-192x192new.png'),
                color: Colors.white,
                onPressed: () {},
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user!.name, style: AppStyle.txtPoppinsSemiBold20Black),
                    Text(user!.nameComercial,
                        style: AppStyle.txtPoppinsSemiBold14Black),
                    const SizedBox(height: 31),
                    Text('Ubicación Actual',
                        style: AppStyle.txtPoppinsSemiBold18Black),
                    const SizedBox(height: 10),
                    LocationCard(),
                    const SizedBox(height: 31),
                    Text('Servicios', style: AppStyle.txtPoppinsMedium18Black),
                    const SizedBox(height: 16),
                    _ListCourt(user: user),
                    const SizedBox(height: 40),
                    Text('Servicios programados',
                        style: AppStyle.txtPoppinsMedium18Black),
                    const SizedBox(height: 20),
                    const _ListScheduleReservationItems(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
  }
}

class _ListCourt extends StatelessWidget {
  final dynamic user;

  const _ListCourt({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final List<Ticket> tickets = [
      Ticket(
          id: '1',
          title: 'Problema con la conexión',
          description: 'No puedo conectar a internet.'),
      Ticket(
          id: '2',
          title: 'Error en la aplicación',
          description: 'La aplicación se cierra inesperadamente.'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          CardPreview(
            imageUrl: 'assets/images/air-conditioning.png',
            name: 'Nuevos',
            type: '',
            rainyPercentage: user.ntickets.toString(),
            image: 'assets/images/call-service2.png',
            gradientColors: [
              Colors.lightBlue.shade100,
              Colors.lightBlue.shade200
            ],
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TicketsListFiltered(),
                  ));
            },
          ),
          const SizedBox(width: 20),
          CardPreview(
            imageUrl: 'assets/images/settings.png',
            name: 'En proceso',
            type: '',
            rainyPercentage: user.ntickets.toString(),
            image: 'assets/images/court1.png',
            gradientColors: [Colors.blue.shade100, Colors.blue.shade200],
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TicketsListFiltered(),
                  ));
            },
          ),
          const SizedBox(width: 20),
          CardPreview(
            imageUrl: 'assets/images/inspection.png',
            name: 'Histórico',
            type: '',
            rainyPercentage: '15',
            image: 'assets/images/court1.png',
            gradientColors: [Colors.cyan.shade100, Colors.cyan.shade200],
            onTap: () {
              Navigator.pushNamed(context, TicketsListFiltered.route);
            },
          ),
        ],
      ),
    );
  }
}

class _ListScheduleReservationItems extends StatefulWidget {
  const _ListScheduleReservationItems();

  @override
  __ListScheduleReservationItemsState createState() =>
      __ListScheduleReservationItemsState();
}

class __ListScheduleReservationItemsState
    extends State<_ListScheduleReservationItems> {
  Future<List<Visit>>? _visitsFuture;

  @override
  void initState() {
    super.initState();
    _visitsFuture = fetchVisitsByTicket();
  }

  Future<List<Visit>> fetchVisitsByTicket() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    final response = await http.get(
      Uri.parse(
          'http://3.137.100.242:3000/api/v1/technical-visits?sort=visit_date'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> visitsData = json.decode(response.body)['data'];
      if (visitsData.isEmpty) {
        return [];
      }
      return visitsData
          .map<Visit>(
              (dynamic item) => Visit.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load visits for ticket');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Visit>>(
      future: _visitsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No visits found.'));
        }

        final visits = snapshot.data!;

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visits.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TicketAcceptedProgressDetailPage(
                          ticketId: visits[index]
                              .ticketId
                              .toString())), // Ensure toString() is used here
                )
              },
              child: ReservationItem(
                title: 'Ticket ${visits[index].ticketId}',
                description: visits[index].observations ?? '',
                date: DateFormat('yyyy-MM-dd').format(visits[index].visitDate),
                time: DateFormat('hh:mm a').format(visits[index].visitDate),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        );
      },
    );
  }
}

class ReservationItem extends StatelessWidget {
  const ReservationItem({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
  });

  final String title;
  final String description;
  final String date;
  final String time;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Image(
          image: AssetImage(
        'assets/images/wrench.png',
      )), // Ícono de herramientas
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            const Row(
            children: [
              SizedBox(width: 5),
              Text('Visita programada', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, ),),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 5),
              Text(date),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16),
              const SizedBox(width: 5),
              Text(time),
            ],
          ),
          Text(description),
        ],
      ),
      trailing: const Icon(Icons.edit,
          color: Colors.grey), // Ícono de lápiz para editar
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
      child: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: false,
        leading: leading,
        elevation: 0.0,
        toolbarHeight: 64,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Inicio',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        actions: actions,
        flexibleSpace: Container(
          height: 200,
          alignment: Alignment.bottomLeft,
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
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
