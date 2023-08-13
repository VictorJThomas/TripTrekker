import 'package:flutter/material.dart';
import 'package:triptekker/views/favorites/models/favorite.dart';

class FavoritesViewScreen extends StatelessWidget {
  final Favorite favorite;

  FavoritesViewScreen({required this.favorite});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de los favoritos'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${favorite.title}'),
            Text('Date: ${favorite.date.toString()}'),
          ],
        ),
      ),
    );
  }
}
