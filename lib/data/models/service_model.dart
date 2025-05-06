class ServiceModel {
  final String? id;
  final String name;
  final String category;
  final double price;
  final String? imageUrl;
  final bool availability;
  final int duration;
  final double rating;

  ServiceModel({
    this.id,
    required this.name,
    required this.category,
    required this.price,
    this.imageUrl,
    required this.availability,
    required this.duration,
    required this.rating,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      availability: json['availability'],
      duration: json['duration'],
      rating: json['rating'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'availability': availability,
      'duration': duration,
      'rating': rating,
    };
  }
}
