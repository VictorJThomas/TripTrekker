import 'package:hive/hive.dart';

part 'favorite.g.dart';

@HiveType(typeId: 0)
class Favorite extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String imagePath;

  @HiveField(2)
  late DateTime date;

  @HiveField(3)
  late String location; 

  @HiveField(4)
  late String description;

  Favorite({
    required this.title,
    required this.imagePath,
    required this.date,
    required this.location,
    required this.description,
  });
}
