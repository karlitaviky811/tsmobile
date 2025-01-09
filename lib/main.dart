import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:tsmobile/src/features/main/screens/splash_screen.dart';
import 'package:tsmobile/src/providers/geolocation_provider.dart';
import 'package:tsmobile/src/providers/image_provider.dart';
import 'package:tsmobile/src/providers/image_provider_close_ticket.dart';
import 'package:tsmobile/src/providers/image_provider_diagnostic.dart';
import 'package:tsmobile/src/providers/image_provider_new.dart';
import 'package:tsmobile/src/providers/image_provider_spare_parts.dart';
import 'package:tsmobile/src/providers/image_provider_visit.dart';
import 'package:tsmobile/src/providers/message_provider.dart';
import 'package:tsmobile/src/providers/provider_invoice_spare_parts.dart';
import 'package:tsmobile/src/providers/provider_technical_buy_spare_parts.dart';
import 'package:tsmobile/src/providers/tikets_provider.dart';
import 'package:tsmobile/src/providers/user_provider.dart';
import 'package:tsmobile/src/providers/visit_provider.dart';
import 'package:tsmobile/src/routes/router_app.dart';
// Importa la pantalla de splash
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  tz.initializeTimeZones();

  // Fecha y hora en UTC
  final utcDateTime =
      tz.TZDateTime.parse(tz.UTC, '2024-12-28T18:30:00.000000Z');

  // Zona horaria de Caracas
  final caracas = tz.getLocation('America/Caracas');

  // Convertir a la zona horaria de Caracas
  final caracasDateTime = tz.TZDateTime.from(utcDateTime, caracas);

  print(caracasDateTime);
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
        ChangeNotifierProvider(create: (_) => ImagesVisitProviderModel()),
        ChangeNotifierProvider(create: (_) => ImageProviderSpareParts()),
        ChangeNotifierProvider(
            create: (_) => ImageProviderTechnicalBuySpareParts()),
        ChangeNotifierProvider(create: (_) => ImageProviderTechnicalInvoice()),
        ChangeNotifierProvider(create: (_) => ImageProviderSparePartsNew()),
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
