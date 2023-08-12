import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'favorites_details_screen.dart';
import 'favorites_form_screen.dart';
import 'helper/favorite_provider.dart';

class FavoritesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lugares Favoritos del Usuario'),
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          final favorites = favoritesProvider.favorites;
          if (favorites.isEmpty) {
            return Center(
              child: Text('Aún no tienes lugares favoritos.'),
            );
          }
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(favorites[index].title),
                subtitle: Text(favorites[index].date.toString()),
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/placeholder_image.jpg'),
                  // You can update this with the actual image path
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoriteDetailsView(
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FavoritesFormView()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
