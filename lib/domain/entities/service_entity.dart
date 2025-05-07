class ServiceEntity {
   String? id;
   String name;
   String category;
   double price;
   String? imageUrl;
   bool availability;
   int duration; // in minutes
   double rating; // 1-5

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
