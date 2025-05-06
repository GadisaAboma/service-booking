class ServiceEntity {
  final String? id;
  final String name;
  final String category;
  final double price;
  final String? imageUrl;
  final bool availability;
  final int duration; // in minutes
  final double rating; // 1-5

  ServiceEntity({
    this.id,
    required this.name,
    required this.category,
    required this.price,
    this.imageUrl,
    this.availability = true,
    required this.duration,
    this.rating = 0.0,
  });
}
