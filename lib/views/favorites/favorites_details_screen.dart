import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/favorite.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FavoriteDetailsView extends StatelessWidget {
  final Favorite favorite;

  FavoriteDetailsView({required this.favorite});

  @override
  Widget build(BuildContext context) {
    // Convertir la fecha de String a DateTime
    final date = favorite.date;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalles del Lugar Favorito',
          style: (TextStyle(color: Colors.black)),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context); // Regresar a la vista anterior
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                favorite.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Fecha',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                date,
              ),
            ),
            ListTile(
              title: Text(
                'Descripción',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                favorite.description,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectedLocationMapScreen(
                      initialLocation: favorite.location,
                    ),
                  ),
                );
              },
              child: ListTile(
                title: Text(
                  'Ubicación',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: RichText(
                  text: TextSpan(
                    text: 'Latitud ${favorite.location}',
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ),
            if (favorite.imagePath.isNotEmpty) ...[
              SizedBox(height: 16),
              ListTile(
                title: Text(
                  'Imagen',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Image.file(
                  File(favorite.imagePath),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SelectedLocationMapScreen extends StatefulWidget {
  final String initialLocation;

  SelectedLocationMapScreen({required this.initialLocation});

  @override
  _SelectedLocationMapScreenState createState() =>
      _SelectedLocationMapScreenState();
}

class _SelectedLocationMapScreenState extends State<SelectedLocationMapScreen> {
  GoogleMapController? googleMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubicación Seleccionada'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _parseLatLng(widget.initialLocation),
          zoom: 14.0,
        ),
        onMapCreated: (controller) {
          setState(() {
            googleMapController = controller;
          });
        },
        markers: _createMarkers(),
      ),
    );
  }

  LatLng _parseLatLng(String latLngString) {
    final latLngWithoutPrefix =
        latLngString.replaceAll('Latitud ', '').replaceAll('Longitud ', '');
    List<String> latLng = latLngWithoutPrefix.split(',');
    double lat = double.parse(latLng[0]);
    double lng = double.parse(latLng[1]);
    return LatLng(lat, lng);
  }

  Set<Marker> _createMarkers() {
    return {
      Marker(
        markerId: MarkerId("selected"),
        position: _parseLatLng(widget.initialLocation),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    };
  }
}
