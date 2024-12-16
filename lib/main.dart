import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tsmobile/src/features/main/screens/splash_screen.dart';
import 'package:tsmobile/src/providers/geolocation_provider.dart';
import 'package:tsmobile/src/providers/image_provider.dart';
import 'package:tsmobile/src/providers/message_provider.dart';
import 'package:tsmobile/src/providers/tikets_provider.dart';
import 'package:tsmobile/src/providers/user_provider.dart';
import 'package:tsmobile/src/providers/visit_provider.dart';
import 'package:tsmobile/src/routes/router_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';
// Importa la pantalla de splash

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  final oneSignalAppId = dotenv.env['APP_ID'];
  WidgetsFlutterBinding.ensureInitialized();

  await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize(oneSignalAppId as String);

  // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt.
  // We recommend removing the following code and instead using an In-App Message to prompt for notification permission.
  OneSignal.User.addAlias('external_id', 'userId-test-1');
  OneSignal.login('userId-test-1');
  if ((OneSignal.User.pushSubscription.id == null)) {
    OneSignal.Notifications.requestPermission(true);
  }
  PusherChannelsPackageLogger.enableLogs();
  // Create an instance PusherChannelsOptions
  // The test options can be accessed from test.pusher.com (using only for test purposes)
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
