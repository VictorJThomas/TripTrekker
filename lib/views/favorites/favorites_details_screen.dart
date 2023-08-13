import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/favorite.dart';

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
