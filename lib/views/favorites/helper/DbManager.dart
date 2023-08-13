import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:triptekker/views/favorites/models/favorite.dart';

class DbManager {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    if (_database == null) {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, 'favoritos.db');

      return openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE favorito(id INTEGER PRIMARY KEY, title TEXT, date TEXT, location TEXT, description TEXT, imagepath TEXT, userId TEXT)',
          );
        },
      );
    }

    return _database!;
  }

  static Future<List<Favorite>> getEntries() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorito');

    return List.generate(maps.length, (i) {
      return Favorite(
        id: maps[i]['id'],
        title: maps[i]['title'],
        date: maps[i]['date'],
        location: maps[i]['location'],
        description: maps[i]['description'],
        imagePath: maps[i]['imagepath'],
        userId: maps[i]['userId'],
      );
    });
  }

  static Future<void> addEntry(Favorite entry) async {
    final db = await database;

    await db.insert(
      'favorito',
      {
        'title': entry.title,
        'date': entry.date,
        'location': entry.location,
        'description': entry.description,
        'imagepath': entry.imagePath,
        'userId': entry.userId,
      },
    );
  }

  static Future<void> deleteAllEntries() async {
    final db = await database;

    // Obtener todas las entradas existentes
    final entries = await db.query('favotito');

    for (final entry in entries) {
      final imagePath = entry['imagepath'] as String?;
      if (imagePath != null) {
        final imageFile = File(imagePath);
        if (imageFile.existsSync()) {
          await imageFile.delete();
        }
      }
    }

    await db.delete('favorito');
  }

  static Future<int?> deleteEntry(int? id) async {
    final db = await database;
    final entryToDelete =
        await db.query('favorito', where: "id = ?", whereArgs: [id]);

    // Eliminar los archivos de imagen asociados a la entrada
    for (final entry in entryToDelete) {
      final imagePath = entry['imagepath'] as String?;
      if (imagePath != null) {
        final imageFile = File(imagePath);
        if (imageFile.existsSync()) {
          await imageFile.delete();
        }
      }
    }

    return await db.delete('favorito', where: "id = ?", whereArgs: [id]);
  }

  static Future<List<Favorite>> getFavoritesByUserId(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorito',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return Favorite(
        id: maps[i]['id'],
        title: maps[i]['title'],
        date: maps[i]['date'],
        location: maps[i]['location'],
        description: maps[i]['description'],
        imagePath: maps[i]['imagepath'],
        userId: maps[i]['userId'],
      );
    });
  }
}
