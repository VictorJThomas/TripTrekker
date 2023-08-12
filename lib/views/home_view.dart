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
          backgroundColor: _colorScheme.primary, // Color de fondo de la AppBar
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(0.0),
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
              _buildIconButton(0, Icons.camera_alt),
              VerticalDivider(
                color: _colorScheme.onSurface, // Aplica el color en superficie
                thickness: 2.0,
              ),
              _buildIconButton(1, Icons.location_on),
              VerticalDivider(
                color: _colorScheme.onSurface, // Aplica el color en superficie
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
            ? Colors.white // Cambia el color a blanco si está seleccionado
            : iconColors[
                index], // Mantén el color original si no está seleccionado
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
  onSurface: Color.fromARGB(255, 34, 162, 88), // Usar el color primario
  surface: Color.fromARGB(255, 34, 162, 88), // Usar el color primario
);
