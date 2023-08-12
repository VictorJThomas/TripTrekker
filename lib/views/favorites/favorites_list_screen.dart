import 'package:flutter/material.dart';
import 'package:triptekker/views/favorites/helper/favorite_provider.dart';
import 'package:provider/provider.dart';
import 'favorites_view_screen.dart';

class FavoritesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites List'),
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          final favorites = favoritesProvider.favorites;
          if (favorites.isEmpty) {
            return const Center(
              child: Text('No favorites yet.'),
            );
          }
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(favorites[index].title),
                subtitle: Text(favorites[index].date.toString()),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoritesViewScreen(
                        favorite: favorites[index],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the screen to add a new favorite
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
