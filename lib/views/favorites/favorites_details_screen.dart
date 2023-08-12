import 'package:flutter/material.dart';
import 'models/favorite.dart';

class FavoriteDetailsView extends StatelessWidget {
  final Favorite favorite;

  FavoriteDetailsView({required this.favorite});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Lugar Favorito'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              favorite.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Fecha de Creación: ${favorite.date.toString()}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            if (favorite.imagePath.isNotEmpty)
              Image.asset(
                favorite.imagePath,
                height: 200,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 20),
            Text(
              'Ubicación: ${favorite.location}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Descripción:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
