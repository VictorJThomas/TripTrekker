import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'favorites_details_screen.dart';
import 'favorites_form_screen.dart';
import 'helper/DbManager.dart'; // Importa la clase DbManager y Favorite
import 'models/favorite.dart';

class FavoritesView extends StatefulWidget {
  final String userId; // Agrega el parámetro userId al constructor
  FavoritesView({required this.userId});

  @override
  _FavoritesViewState createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
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
        title: Text(
          'Lugares Favoritos del Usuario',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Georgia',
            fontSize: 20,
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
      ),
      body: favorites.isEmpty
          ? Center(
              child: Text('Aún no tienes lugares favoritos.'),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(favorites[index].title),
                  subtitle: Text('Fecha: ' + favorites[index].date.toString()),
                  leading: CircleAvatar(
                    child: ClipOval(
                      child: Image.file(
                        File(favorites[index].imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      // Agregar lógica para eliminar el elemento aquí
                      await DbManager.deleteEntry(favorites[index].id);
                      loadFavorites(); // Actualizar la lista
                    },
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
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FavoritesFormView(userId: widget.userId),
            ),
          ).then((_) {
            // Actualizar la lista cuando se regrese de la vista de agregar favorito
            loadFavorites();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
