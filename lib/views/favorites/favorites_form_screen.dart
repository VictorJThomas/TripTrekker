import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:triptekker/views/favorites/models/favorite.dart';

import 'helper/DbManager.dart';

class FavoritesFormView extends StatefulWidget {
  final String userId; // Agregar userId al constructor
  FavoritesFormView({required this.userId});

  @override
  _FavoritesFormViewState createState() => _FavoritesFormViewState();
}

class _FavoritesFormViewState extends State<FavoritesFormView> {
  final _formKey = GlobalKey<FormState>();

  XFile? _image;
  String? title;
  String? description;

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
        location: '',
        date: dateText,
        userId: widget.userId,
      );
      await DbManager.addEntry(newFavorite); // Sube los datos

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
            Navigator.pop(context); // Regresar a la vista anterior
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
                  decoration: InputDecoration(labelText: 'Título'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un título';
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
