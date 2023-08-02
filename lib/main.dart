import 'package:flutter/material.dart';

import 'camera_view.dart';
import 'user_view.dart';
import 'home_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 1; // Índice de la página principal

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trip Trekker',
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Trip Trekker',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 4,
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40.0),
              bottomRight: Radius.circular(40.0),
            ),
          ),
        ),
        body: Center(
          child: _buildCurrentView(), // Mostrar la vista actual según el índice
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
    );
  }

  Widget _buildCurrentView() {
    switch (_currentIndex) {
      case 0:
        return CameraView();
      case 1:
        return const HomeView();
      case 2:
        return const UserView();
      default:
        return Container();
    }
  }
}

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MyBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.black,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => onTap(0),
            ),
            VerticalDivider(
              color: Colors.white,
              thickness: 2.0,
            ),
            IconButton(
              icon: Icon(Icons.location_on,
                  color: Color.fromARGB(255, 208, 138, 220), size: 30),
              onPressed: () => onTap(1),
            ),
            VerticalDivider(
              color: Colors.white,
              thickness: 2.0,
            ),
            IconButton(
              icon: Icon(Icons.person_3_rounded, color: Colors.white, size: 30),
              onPressed: () => onTap(2),
            ),
          ],
        ),
      ),
    );
  }
}

class University {
  final String name;
  final String domain;
  final String webPage;

  University({
    required this.name,
    required this.domain,
    required this.webPage,
  });
}
