import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:triptekker/views/login/BienvenidoView.dart';

import 'views/home_view.dart';

void main() async {
  // Inicialziar firebase antes de correr la app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trip Trekker',
      theme: ThemeData(
        colorSchemeSeed: Color.fromARGB(255, 34, 162, 88),
        useMaterial3: true,
      ),
      initialRoute: '/', // Set the initial route
      routes: {
        '/': (context) => const BienvenidoView(),
        '/home': (context) => const TripTrekkerApp(),
      },
    );
  }
}
