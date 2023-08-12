import 'package:flutter/material.dart';
import 'package:triptekker/views/favorites/models/favorite.dart';

class FavoritesViewScreen extends StatelessWidget {
  final Favorite favorite;

  FavoritesViewScreen({required this.favorite});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${favorite.title}'),
            Text('Date: ${favorite.date.toString()}'),
            // Display other favorite details as needed
          ],
        ),
      ),
    );
  }
}
