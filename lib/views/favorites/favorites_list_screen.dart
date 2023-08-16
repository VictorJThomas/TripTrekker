import 'package:flutter/material.dart';
import 'package:triptekker/views/favorites/models/favorite.dart';
import 'favorites_form_screen.dart';
import 'favorites_view_screen.dart';
import 'helper/DbManager.dart';

class FavoritesListScreen extends StatefulWidget {
  final String userId; // Agregar userId al constructor
  FavoritesListScreen({required this.userId});

  @override
  _FavoritesListScreenState createState() => _FavoritesListScreenState();
}

class _FavoritesListScreenState extends State<FavoritesListScreen> {
  late List<Favorite> favorites; // Lista de favoritos

  @override
  void initState() {
    super.initState();
    loadFavorites(); // Cargar los favoritos al iniciar
  }

  Future<void> loadFavorites() async {
    favorites = await DbManager.getFavoritesByUserId(
        widget.userId); // Obtener favoritos del usuario
    setState(() {}); // Actualizar la vista
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de favoritos'),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text('No hay favoritos aun.'),
            )
          : ListView.builder(
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
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FavoritesFormView(
                  userId: widget
                      .userId), // Pasar el userId a la vista de agregar favorito
            ),
          ).then((_) {
            // Actualizar la lista cuando se regrese de la vista de agregar favorito
            loadFavorites();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
