import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as places;
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;
import 'dart:math' show sin, cos, sqrt, atan2;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = Set<Marker>();
  final _places = places.GoogleMapsPlaces(
      apiKey: 'AIzaSyAY3GtsN69ANEf01HF1h8L0Sto2Bmu0T54');
  final TextEditingController _searchController = TextEditingController();
  List<places.Prediction> _predictions = [];
  double? _userLat;
  double? _userLng;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _searchController.addListener(_onSearchChanged);
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('marker'),
          position: point,
        ),
      );
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: LatLng(_userLat ?? 0, _userLng ?? 0),
              zoom: 14.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            padding: EdgeInsets.only(right: 10.0),
          ),
          Positioned(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            child: _buildSearchField(),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90.0),
        child: FloatingActionButton(
          onPressed: _getCurrentLocation,
          mini: true,
          child: const Icon(Icons.my_location),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSearchField() {
    return Container(
      color: Colors.white,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Busca una ubicacion',
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          suffixIcon: const Icon(Icons.search),
        ),
        onSubmitted: (query) {
          _searchPlaces(query);
        },
      ),
    );
  }

  void _onSearchChanged() {
    _searchPlaces(_searchController.text);
  }

  Future<void> _getCurrentLocation() async {
    loc.LocationData? locationData;
    var location = loc.Location();

    try {
      locationData = await location.getLocation();
    } catch (e) {
      locationData = null;
    }

    if (locationData != null) {
      setState(() {
        _userLat = locationData?.latitude;
        _userLng = locationData?.longitude;
      });

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(_userLat!, _userLng!), zoom: 14),
        ),
      );

      _setMarker(LatLng(_userLat!, _userLng!));

      _searchPlaces(_searchController.text);
    }
  }

  Future<void> _searchPlaces(String query) async {
    if (_userLat == null || _userLng == null) {
      // User's current location not available
      return;
    }

    final response = await _places.autocomplete(
      query,
      location: places.Location(lat: _userLat!, lng: _userLng!),
      radius: 5000, // Specify the search radius in meters
      types: ['geocode'],
    );

    if (response.isOkay) {
      setState(() {
        _predictions = response.predictions;
        if (_predictions.isNotEmpty) {
          final placeId = _predictions[0].placeId;
          if (placeId != null) {
            _getPlaceDetails(placeId);
          }
        }
      });
    } else {
      // Handle the error here
      print("Error fetching predictions: ${response.errorMessage}");
    }
  }

  Future<void> _getPlaceDetails(String placeId) async {
    final response = await _places.getDetailsByPlaceId(placeId);
    if (response.isOkay && response.result != null) {
      final location = response.result.geometry?.location;
      if (location != null) {
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(location.lat, location.lng), 14.0),
        );
        _setMarker(LatLng(location.lat, location.lng));
      }
    }
  }
}
