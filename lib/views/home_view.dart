import 'package:flutter/material.dart';
import 'package:triptekker/views/camera_view.dart';
import 'package:triptekker/views/user_view.dart';

import '../home/home.dart';

void main() {
  runApp(TripTrekkerApp());
}

class TripTrekkerApp extends StatefulWidget {
  const TripTrekkerApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TripTrekkerAppState();
}

class _TripTrekkerAppState extends State<TripTrekkerApp> {
  int _currentIndex = 1; 

  late List<Color> _iconColors; 

  @override
  void initState() {
    super.initState();
    _iconColors = List.generate(
      3,
      (index) => index == _currentIndex
          ? _colorScheme.onPrimary
          : _colorScheme.secondary, 
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trip Trekker',
      theme: ThemeData(
        colorScheme: _colorScheme, 
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Trip Trekker',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          elevation: 4,
          backgroundColor: _colorScheme.primary, 
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(0.0),
            ),
          ),
        ),
        body: Center(
          child: _buildCurrentView(), 
        ),
        bottomNavigationBar: MyBottomNavigationBar(
          currentIndex: _currentIndex,
          iconColors: _iconColors, 
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
              _iconColors = List.generate(
                3,
                (i) => i == index
                    ? _colorScheme.onPrimary
                    : _colorScheme
                        .secondary, 
              );
            });
          },
        ),
      ),
    );
  }

  Widget _buildCurrentView() {
    return Expanded(
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: _getCurrentView(),
      ),
    );
  }

  Widget _getCurrentView() {
    switch (_currentIndex) {
      case 0:
        return CameraView();
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
  final List<Color> iconColors;
  final Function(int) onTap;

  const MyBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.iconColors,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: BottomAppBar(
        color: _colorScheme.primary, 
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIconButton(0, Icons.camera_alt),
              VerticalDivider(
                color: _colorScheme.onSurface, 
                thickness: 2.0,
              ),
              _buildIconButton(1, Icons.location_on),
              VerticalDivider(
                color: _colorScheme.onSurface, 
                thickness: 2.0,
              ),
              _buildIconButton(2, Icons.person_3_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(int index, IconData icon) {
    return IconButton(
      icon: Icon(
        icon,
        color: index == currentIndex
            ? Colors.white 
            : iconColors[
                index], 
        size: 25,
      ),
      onPressed: () => onTap(index),
    );
  }
}

final ColorScheme _colorScheme = ColorScheme(
  primary: Color.fromARGB(255, 34, 162, 88),
  onPrimary: Color.fromARGB(255, 0, 0, 0),
  background: Color.fromARGB(255, 255, 255, 255),
  brightness: Brightness.light,
  error: Color.fromARGB(255, 78, 0, 0),
  onBackground: Color.fromARGB(255, 34, 162, 88),
  onError: Color.fromARGB(255, 255, 255, 255),
  secondary: Color.fromARGB(255, 0, 0, 0),
  onSecondary: Color.fromARGB(255, 255, 255, 255),
  onSurface: Color.fromARGB(255, 34, 162, 88), 
  surface: Color.fromARGB(255, 34, 162, 88), 
);