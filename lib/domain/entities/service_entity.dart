class ServiceEntity {
  String? id;

  String name;

  String category;

  double price;

  String? imageUrl;

  bool availability;

  int duration;

  double rating;

  ServiceEntity({
    this.id,
    required this.name,
    required this.category,
    required this.price,
    this.imageUrl,
    required this.availability,
    required this.duration,
    this.rating = 0,
  });
}
