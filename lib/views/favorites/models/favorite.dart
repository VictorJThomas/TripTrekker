class Favorite {
  late final String title;

  late final String imagePath;
  final String date;
  late String location;
  late String description;
  final int? id;
  late final String userId;

  Favorite({
    this.id,
    required this.title,
    required this.imagePath,
    required this.date,
    required this.location,
    required this.description,
    required this.userId,
  });
}
