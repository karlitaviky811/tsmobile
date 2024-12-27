import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/features/main/screens/location_card.dart';
import 'package:flutter/material.dart';
import 'package:tsmobile/src/features/main/screens/list_tickets_page.dart';
import 'package:tsmobile/src/features/main/screens/notifications_screen.dart';
import 'package:tsmobile/src/features/main/screens/ticket_accepted_progress.dart';
import 'package:tsmobile/src/interfaces/ticket.dart';
import 'package:tsmobile/src/models/auth_model.dart';
import 'package:tsmobile/src/providers/user_provider.dart';
import 'package:tsmobile/src/services/user_service.dart';
import '../../../widgets/index.dart';

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
    final userService = new UserProvider();
    Future<void> fetchedUser = userService.obatinUserData();
    await dotenv.load(fileName: ".env");
    await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    fetchedUser.then((_) {
      setState(() {
        user = userService.user;

        final oneSignalAppId = dotenv.env['APP_ID'];
        String _debugLabelString = "";
        WidgetsFlutterBinding.ensureInitialized();

        OneSignal.initialize(oneSignalAppId as String);
          final String userTag = userService.user!.id.toString();
        // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt.
        // We recommend removing the following code and instead using an In-App Message to prompt for notification permission.
        print('epa ${userService.user}');
        if ((OneSignal.User.pushSubscription.id == null)) {
          OneSignal.Notifications.requestPermission(true);
          print('epa $userTag');
        
          //OneSignal.User.addAlias('external_id', "technical-userService.user!.id}");
          //OneSignal.User.addTagWithKey('external_id', 'technical-userService.user!.id');
          // OneSignal.login('technical-20');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return user == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            key: _scaffoldKey,
            appBar: CustomAppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {
                    // Acción de notificaciones
                    print('Notificaciones');

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
                color: Colors.white, // Cambiar color aquí
                onPressed: () {
                  //_scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user!.name,
                          style: AppStyle.txtPoppinsSemiBold20Black),
                      Text(user!.nameComercial,
                          style: AppStyle.txtPoppinsSemiBold14Black),
                      const SizedBox(height: 31),
                      Text('Ubicación Actual',
                          style: AppStyle.txtPoppinsSemiBold18Black),
                      const SizedBox(height: 10),
                      LocationCard(),
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
          CardPreviewCourt(
            imageUrl: 'assets/images/air-conditioning.png',
            name: 'Nuevos',
            type: '',
            rainyPercentage: '30',
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
          CardPreviewCourt(
            imageUrl: 'assets/images/settings.png',
            name: 'En proceso',
            type: '',
            rainyPercentage: '10',
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
          CardPreviewCourt(
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

class _ListScheduleReservationItems extends StatelessWidget {
  const _ListScheduleReservationItems();

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
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TicketAcceptedProgressDetailPage(
                      ticketId: tickets[0].id)),
            )
          },
          child: ReservationItem(
            title: 'Título del Ticket $index',
            description: 'Descripción del Ticket $index',
            date: '2024-11-1${index + 7}',
            time: '${10 + index}:00 AM',
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
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

                //Color(0xff051937),
                //Color(0XFF131314),
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
