import 'package:flutter/material.dart';
import 'package:tsmobile/src/features/main/screens/tab1_page.dart';
import 'package:tsmobile/src/features/main/screens/tabs_page.dart';
import 'package:tsmobile/src/routes/router_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  final oneSignalAppId = dotenv.env['APP_ID'];
  WidgetsFlutterBinding.ensureInitialized();

  await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize(oneSignalAppId as String);

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);

  OneSignal.User.addAlias('external_id', 'userId-test-1');
  OneSignal.login('userId-test-1');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Color(0xffF3F5FD)
      ),
      home: const TabsPage(),
      routes: RouterApp.getRoutes(),
      initialRoute: RouterApp.initialRoute,

    );
  }
}