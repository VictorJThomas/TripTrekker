// Importaciones de paquetes necesarios
import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_webservice/directions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_webservice/places.dart';
import 'package:dio/dio.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:location/location.dart';

import '../views/favorites/favorites_form_screen.dart';

// Clase que define la pantalla del mapa

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => MapScreenState();
}

const kGoogleApiKey = 'AIzaSyAY3GtsN69ANEf01HF1h8L0Sto2Bmu0T54';
final homeScaffoldKey = GlobalKey<ScaffoldState>();

// Estado de la pantalla del mapa
class MapScreenState extends State<MapScreen> {
  // Posición inicial de la cámara
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(24.42798, -121.09575), zoom: 14.0);

  // Lista de marcadores en el mapa
  Set<Marker> markersList = {};

  // Controlador del mapa de Google
  late GoogleMapController googleMapController;

  // Modo de visualización del mapa
  final Mode _mode = Mode.overlay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      // Cuerpo de la pantalla
      body: Stack(
        children: [
          // Widget de Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(24.42798, -121.09575),
              zoom: 14.0,
            ),
            markers: markersList,
            mapType: MapType.normal,
            // Callback cuando se crea el mapa
            onMapCreated: (GoogleMapController controller) async {
              googleMapController = controller;

              // Obtener la ubicación actual del dispositivo
              LocationData? currentLocation = await _getCurrentLocation();
              if (currentLocation != null) {
                // Animar la cámara para centrarse en la ubicación actual
                googleMapController.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(
                        currentLocation.latitude!, currentLocation.longitude!),
                    14.0,
                  ),
                );
                // Agregar un marcador en la ubicación actual
                markersList.add(Marker(
                  markerId: const MarkerId("current"),
                  position: LatLng(
                      currentLocation.latitude!, currentLocation.longitude!),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure),
                ));
                // Actualizar el estado para reflejar los cambios en el mapa
                setState(() {});
              }
            },
          ),
          // Botón para buscar destinos
          ElevatedButton(
            onPressed: _handlePressButton,
            child: const Text("Buscar Destinos"),
          ),
          // Botón para centrar el mapa en la ubicación actual
          Positioned(
            top: 16.0,
            right: 16.0,
            child: ElevatedButton(
              onPressed: _goToCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  // Definir la función para centrar el mapa en la ubicación actual
  void _goToCurrentLocation() async {
    LocationData? currentLocation = await _getCurrentLocation();
    if (currentLocation != null && googleMapController != null) {
      googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(currentLocation.latitude!, currentLocation.longitude!),
          14.0,
        ),
      );
    }
  }

  // Manejar la acción del botón "Buscar Destinos"
  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white))),
        components: [
          Component(Component.country, "do"),
        ]);

    // Mostrar los detalles del lugar seleccionado
    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  // Manejar errores durante la búsqueda de lugares
  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Message',
        message: response.errorMessage!,
        contentType: ContentType.failure,
      ),
    ));
  }

  // Obtener la ubicación actual del dispositivo
  Future<LocationData?> _getCurrentLocation() async {
    final location = loc.Location();
    try {
      return await location.getLocation();
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  // Mostrar los detalles del lugar seleccionado y actualizar el mapa
  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markersList.clear();
    markersList.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));

    setState(() {});

    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));

    _showFormWithPlaceDetails(detail.result.name, LatLng(lat, lng));
  }

  void _showFavoritesForm(String title, LatLng location, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritesFormView(
          userId: userId,
          title: title,
          location: location,
        ),
      ),
    );
  }

  void _showFormWithPlaceDetails(String title, LatLng location) async {
    LocationData? currentLocation = await _getCurrentLocation();

    if (currentLocation != null) {
      try {
        String origins =
            '${currentLocation.latitude},${currentLocation.longitude}';
        String destinations = '${location.latitude},${location.longitude}';

        var response = await Dio().get(
          'https://maps.googleapis.com/maps/api/distancematrix/json',
          queryParameters: {
            'units': 'imperial',
            'origins': origins,
            'destinations': destinations,
            'key': kGoogleApiKey,
          },
        );

        if (response.statusCode == 200) {
          final data = response.data;
          dynamic durationData = data['rows'][0]['elements'][0]['duration'];

          String durationText =
              durationData != null && durationData['text'] != null
                  ? durationData['text']
                  : 'Duración no disponible';

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Detalles del Lugar'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Título: $title'),
                    SizedBox(height: 10),
                    Text(
                        'Ubicación: Latitud ${location.latitude}, Longitud ${location.longitude}'),
                    Text('Estimación de tiempo de llegada: $durationText'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showAddTitleAndLocationForm(title, location);
                    },
                    child: Text('Añadir a favoritos'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Cerrar el diálogo
                    },
                    child: Text('Cancelar'),
                  ),
                ],
              );
            },
          );
        } else {
          print('Error fetching distance matrix data');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void _showAddTitleAndLocationForm(String title, LatLng location) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Obtener el usuario autenticado
        User? user = FirebaseAuth.instance.currentUser;

        return AlertDialog(
          title: Text('Agregar Título'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(labelText: 'Título'),
                onChanged: (value) {
                  setState(() {
                    title = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (user != null) {
                  _showFavoritesForm(
                      title, location, user.uid); // Pasa el userId
                }
              },
              child: Text('Continuar'),
            ),
          ],
        );
      },
    );
  }
}
