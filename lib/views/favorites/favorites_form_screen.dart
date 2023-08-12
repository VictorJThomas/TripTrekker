import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:triptekker/views/favorites/helper/favorite_provider.dart';
import 'package:triptekker/views/favorites/models/favorite.dart';

class FavoritesFormView extends StatefulWidget {
  @override
  _FavoritesFormViewState createState() => _FavoritesFormViewState();
}

class _FavoritesFormViewState extends State<FavoritesFormView> {
  final _formKey = GlobalKey<FormState>();

  XFile? _image;
  String? title;
  String? description;

  getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  submitData() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
      final newFavorite = Favorite(
        title: title!,
        description: description!,
        imagePath: _image!.path, 
        location: '',
        date: DateTime.now(),
      );
      favoritesProvider.addFavorite(newFavorite);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a Favorite"),
        actions: [
          IconButton(
            onPressed: submitData,
            icon: Icon(Icons.save),
          )
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
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  autocorrect: false,
                  validator: (val) {
                    if (val?.isEmpty ?? true) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      title = val;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  autocorrect: false,
                  minLines: 2,
                  maxLines: 10,
                  validator: (val) {
                    if (val?.isEmpty ?? true) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      description = val;
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
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        child: Icon(Icons.camera),
      ),
    );
  }
}
