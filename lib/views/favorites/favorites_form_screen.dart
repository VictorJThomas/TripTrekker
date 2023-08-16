import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:triptekker/views/favorites/models/favorite.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'helper/DbManager.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesFormView extends StatefulWidget {
  final String userId;
  final String? title;
  final LatLng? location;

  FavoritesFormView({required this.userId, this.title, this.location});

  @override
  _FavoritesFormViewState createState() => _FavoritesFormViewState();
}

class _FavoritesFormViewState extends State<FavoritesFormView> {
  final _formKey = GlobalKey<FormState>();

  XFile? _image;
  String? title;
  String? description;
  String? location;

  @override
  void initState() {
    super.initState();

    // Inicializa los valores si están disponibles
    title = widget.title ?? '';
    location = widget.location != null
        ? 'Latitud ${widget.location!.latitude}, Longitud ${widget.location!.longitude}'
        : '';
  }

  getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  submitData() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    DateTime date = DateTime.now();
    String dateText = date.toString();
    if (isValid) {
      final newFavorite = Favorite(
        title: title!,
        description: description!,
        imagePath: _image!.path,
        location: location!,
        date: dateText,
        userId: widget.userId,
      );
      await DbManager.addEntry(newFavorite);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Añadir favorito",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: submitData,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                TextFormField(
                  initialValue: title, // Rellenar el título si está disponible
                  decoration: InputDecoration(labelText: 'Título'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Título';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una descripción';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  initialValue:
                      location, // Rellenar la ubicación si está disponible
                  decoration: InputDecoration(labelText: 'Ubicacion'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ubicacion';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      location = value;
                    });
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                _image == null
                    ? Container()
                    : Image.file(
                        File(_image!.path),
                      ),
                SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                  onPressed: submitData,
                  child: Text(
                    'Añadir a favoritos',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        child: Icon(Icons.image),
      ),
    );
  }
}
