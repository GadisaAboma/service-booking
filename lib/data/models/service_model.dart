class ServiceModel {
  final String? id;
  final String? name;
  final String? category;
  final double? price;
  final String? imageUrl;
  final bool? availability;
  final int? duration;
  final double? rating;

  ServiceModel({
    this.id,
    this.name,
    this.category,
    this.price,
    this.imageUrl,
    this.availability,
    this.duration,
    this.rating,
  });

  factory ServiceModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ServiceModel();
    }

    // Helper function to safely parse different types
    T? safeParse<T>(dynamic value, T? Function(dynamic) parser) {
      try {
        return value != null ? parser(value) : null;
      } catch (e) {
        return null;
      }
    }

    return ServiceModel(
      id: safeParse(json['_id'], (v) => v.toString()),
      name: safeParse(json['name'], (v) => v.toString()),
      category: safeParse(json['category'], (v) => v.toString()),
      price: safeParse(
        json['price'],
        (v) =>
            v is int
                ? v.toDouble()
                : v is double
                ? v
                : double.tryParse(v.toString()),
      ),
      imageUrl: safeParse(json['imageUrl'], (v) => v.toString()),
      availability: safeParse(
        json['availability'],
        (v) => v is bool ? v : v.toString().toLowerCase() == 'true',
      ),
      duration: safeParse(
        json['duration'],
        (v) => v is int ? v : int.tryParse(v.toString()),
      ),
      rating: safeParse(
        json['rating'],
        (v) =>
            v is int
                ? v.toDouble()
                : v is double
                ? v
                : double.tryParse(v.toString()),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // if (id != null) '_id': id,
      // if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (price != null) 'price': price,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (availability != null) 'availability': availability,
      if (duration != null) 'duration': duration,
      if (rating != null) 'rating': rating,
    };
  }

  // Helper methods for default values
  String get nameOrDefault => name ?? 'Unnamed Service';
  String get categoryOrDefault => category ?? 'Uncategorized';
  double get priceOrDefault => price ?? 0.0;
  bool get availabilityOrDefault => availability ?? false;
  int get durationOrDefault => duration ?? 0;
  double get ratingOrDefault => rating ?? 0.0;
}
