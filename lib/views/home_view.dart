import 'package:flutter/material.dart';
import 'package:triptekker/home/home.dart';
import 'package:triptekker/views/camera_view.dart';
import 'package:triptekker/views/user_view.dart';

import 'login/LoginView.dart';

class TripTrekkerApp extends StatefulWidget {
  const TripTrekkerApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TripTrekkerAppState();
}

class _TripTrekkerAppState extends State<TripTrekkerApp> {
  int _currentIndex = 1; // Índice de la página principal

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trip Trekker',
      theme: ThemeData(
        colorSchemeSeed: Color.fromARGB(255, 34, 162, 88),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginView(),
        '/home': (context) => Scaffold(
          appBar: AppBar(
            // ... app bar configuration ...
          ),
          body: Center(
            child: _buildCurrentView(), 
          ),
          bottomNavigationBar: MyBottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      },
    );
  }

  void _navigateToHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false,
    );
  }

  Widget _buildCurrentView() {
    switch (_currentIndex) {
      case 0:
        return const CameraView();
      case 1:
        return MapScreen();
      case 2:
        return UserView();
      default:
        return Container();
    }
  }
}

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MyBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color.fromARGB(255, 34, 162, 88),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => onTap(0),
            ),
            const VerticalDivider(
              color: Colors.white,
              thickness: 2.0,
            ),
            IconButton(
              icon: const Icon(Icons.location_on,
                  color: Color.fromARGB(255, 208, 138, 220), size: 30),
              onPressed: () => onTap(1),
            ),
            const VerticalDivider(
              color: Colors.white,
              thickness: 2.0,
            ),
            IconButton(
              icon: const Icon(Icons.person_3_rounded, color: Colors.white, size: 30),
              onPressed: () => onTap(2),
            ),
          ],
        ),
      ),
    );
  }
}
