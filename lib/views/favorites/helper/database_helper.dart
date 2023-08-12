import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:triptekker/views/favorites/models/favorite.dart';

class DatabaseHelper {
  static Future<void> initializeHive() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    // Register your Hive adapter for the Favorite model
    Hive.registerAdapter(FavoriteAdapter());

    await Hive.openBox<Favorite>('favorites');
  }

  static Box<Favorite> getFavoriteBox() {
    return Hive.box<Favorite>('favorites');
  }
}
