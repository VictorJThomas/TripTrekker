import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:triptekker/views/favorites/models/favorite.dart';
import 'package:triptekker/views/login/BienvenidoView.dart';

import 'views/favorites/helper/favorite_provider.dart';

void main() async {
  // Inicialziar firebase antes de correr la app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final appDocumentDir = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.openBox<Favorite>('favorites');

  // Correr la instancia.
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoritesProvider(), // Provide your FavoritesProvider here
      child: MyApp(),
    ),
  );
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
