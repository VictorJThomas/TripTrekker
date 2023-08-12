import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:triptekker/views/favorites/models/favorite.dart';

class FavoritesProvider extends ChangeNotifier {
  late Box<Favorite> _favoriteBox;

  FavoritesProvider() {
    _favoriteBox = Hive.box<Favorite>('favorites');
  }

  List<Favorite> get favorites => _favoriteBox.values.toList();

  Future<void> addFavorite(Favorite favorite) async {
    await _favoriteBox.add(favorite);
    notifyListeners();
  }

  Future<void> updateFavorite(int index, Favorite updatedFavorite) async {
    await _favoriteBox.putAt(index, updatedFavorite);
    notifyListeners();
  }

  Future<void> deleteFavorite(int index) async {
    await _favoriteBox.deleteAt(index);
    notifyListeners();
  }

  Future<void> clearFavorites() async {
    await _favoriteBox.clear();
    notifyListeners();
  }
}
