import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:triptekker/views/login/BienvenidoView.dart';

void main() async {
  // Inicialziar firebase antes de correr la app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.ltr,
      child: MaterialApp(
        home: Scaffold(
          body: BienvenidoView(),
        ),
      ),
    );
  }
}
