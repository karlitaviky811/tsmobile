import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tsmobile/src/features/main/screens/splash_screen.dart';
import 'package:tsmobile/src/models/image_provider_ticket.dart';
import 'package:tsmobile/src/models/image_provider_visit.dart';
import 'package:tsmobile/src/providers/geolocation_provider.dart';
import 'package:tsmobile/src/providers/image_provider.dart';
import 'package:tsmobile/src/providers/image_provider_close_ticket.dart';
import 'package:tsmobile/src/providers/image_provider_diagnostic.dart';
import 'package:tsmobile/src/providers/image_provider_new.dart';
import 'package:tsmobile/src/providers/image_provider_spare_parts.dart';
import 'package:tsmobile/src/providers/image_provider_visit.dart';
import 'package:tsmobile/src/providers/images_provider.dart';
import 'package:tsmobile/src/providers/message_provider.dart';
import 'package:tsmobile/src/providers/provider_invoice_spare_parts.dart';
import 'package:tsmobile/src/providers/provider_technical_buy_spare_parts.dart';
import 'package:tsmobile/src/providers/tikets_provider.dart';
import 'package:tsmobile/src/providers/user_provider.dart';
import 'package:tsmobile/src/providers/visit_provider.dart';
import 'package:tsmobile/src/routes/router_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:tsmobile/src/widgets/images_loaders/image_uploader_invoice_spare_parts.dart';
// Importa la pantalla de splash

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  final oneSignalAppId = dotenv.env['APP_ID'];
  String _debugLabelString = "";
  WidgetsFlutterBinding.ensureInitialized();

  await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize(oneSignalAppId as String);

  // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt.
  // We recommend removing the following code and instead using an In-App Message to prompt for notification permission.
  OneSignal.User.addAlias('external_id', 'technical-20');
  OneSignal.User.addTagWithKey('external_id', 'technical-20');
  OneSignal.login('technical-20');
  if ((OneSignal.User.pushSubscription.id == null)) {
    OneSignal.Notifications.requestPermission(true);
  }

  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    print(
        'NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');

    /// Display Notification, preventDefault to not display
    event.preventDefault();

    /// Do async work

    /// notification.display() to display after preventing default
    event.notification.display();
  });
  PusherChannelsPackageLogger.enableLogs();

  const testOptions = PusherChannelsOptions.fromCluster(
    scheme: 'wss',
    cluster: 'mt1',
    key: 'a0173cd5499b34d93109',
    port: 443,
  );
  // Create an instance of PusherChannelsClient
  final client = PusherChannelsClient.websocket(
    options: testOptions,
    // Connection exceptions are handled here
    connectionErrorHandler: (exception, trace, refresh) async {
      // This method allows you to reconnect if any error is occurred.
      refresh();
    },
  );
  PublicChannel myPublicChannel = client.publicChannel(
    'public-channel',
  );

  StreamSubscription<ChannelReadEvent> somePublicChannelEventSubs =
      myPublicChannel.bind('public-MyEvent').listen((event) {
    print('Event from the public channel fired!');
  });
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MessageProvider()),
        ChangeNotifierProvider(create: (_) => GeolocationProvider()),
        ChangeNotifierProvider(create: (_) => TicketProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ImagePickerProvider()),
        ChangeNotifierProvider(create: (_) => VisitProvider()),
        ChangeNotifierProvider(create: (_) => ImageProviderDiagnostic()),
        ChangeNotifierProvider(create: (_) => ImageProviderVisit()),
        ChangeNotifierProvider(create: (_) => ImagesVisitProviderModel()),
        ChangeNotifierProvider(create: (_) => ImageProviderSpareParts()),
        ChangeNotifierProvider(create: (_)=> ImageProviderTechnicalBuySpareParts()),
        ChangeNotifierProvider(create: (_)=> ImageProviderTechnicalInvoice()),
        ChangeNotifierProvider(create: (_)=> ImageProviderSparePartsNew()),
        
        ChangeNotifierProvider(
            create: (_) => ImageProviderCloseTicketManagement())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        dividerColor: Colors.transparent,
        hintColor: Colors.indigo,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xffF3F5FD),
      ),
      home: SplashScreen(), // Usa SplashScreen como pantalla inicial
      routes: RouterApp.getRoutes(),
    );
  }
}
