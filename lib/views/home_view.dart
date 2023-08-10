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
  int _currentIndex = 1; // Índice de la página principal

  late List<Color> _iconColors; // Arreglo para los colores de los íconos

  @override
  void initState() {
    super.initState();
    _iconColors = List.generate(
      3,
      (index) => index == _currentIndex
          ? _colorScheme.onPrimary // Color cuando está seleccionado
          : _colorScheme.secondary, // Color cuando no está seleccionado
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trip Trekker',
      theme: ThemeData(
        colorScheme: _colorScheme, // Aplica el esquema de colores
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Trip Trekker',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black, // Cambia el color del texto a negro
            ),
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
          iconColors: _iconColors, // Pasar los colores de los íconos
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
              // Actualizar los colores de los íconos al cambiar de índice
              _iconColors = List.generate(
                3,
                (i) => i == index
                    ? _colorScheme.onPrimary // Color cuando está seleccionado
                    : _colorScheme
                        .secondary, // Color cuando no está seleccionado
              );
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
  final List<Color> iconColors; // Colores de los íconos
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
      height: 50, // Ajusta este valor para cambiar la altura del BottomAppBar
      child: BottomAppBar(
        color: _colorScheme.primary, // Aplica el color primario del esquema
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.camera_alt,
                  color: iconColors[0], // Usar el color correspondiente
                  size: 25,
                ),
                onPressed: () => onTap(0),
              ),
              VerticalDivider(
                color: _colorScheme.onSurface, // Aplica el color en superficie
                thickness: 2.0,
              ),
              IconButton(
                icon: Icon(Icons.location_on,
                    color: iconColors[1], // Usar el color correspondiente
                    size: 25),
                onPressed: () => onTap(1),
              ),
              VerticalDivider(
                color: _colorScheme.onSurface, // Aplica el color en superficie
                thickness: 2.0,
              ),
              IconButton(
                icon: Icon(Icons.person_3_rounded,
                    color: iconColors[2], // Usar el color correspondiente
                    size: 25),
                onPressed: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
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
  onSurface: Color.fromARGB(255, 34, 162, 88), // Usar el color primario
  surface: Color.fromARGB(255, 34, 162, 88), // Usar el color primario
);
