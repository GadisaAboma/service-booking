
import 'package:hive/hive.dart';
import 'package:service_booking/data/models/hive_adapter.dart';

part 'hive_service_model.g.dart';

@HiveType(typeId: 0)
class HiveServiceModel {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final String? imageUrl;

  @HiveField(5)
  final bool availability;

  @HiveField(6)
  final int duration;

  @HiveField(7)
  final double rating;

  HiveServiceModel({
    this.id,
    required this.name,
    required this.category,
    required this.price,
    this.imageUrl,
    required this.availability,
    required this.duration,
    this.rating = 0,
  });

  // Add conversion methods
  factory HiveServiceModel.fromEntity(ServiceEntity entity) {
    return HiveServiceModel(
      id: entity.id,
      name: entity.name,
      category: entity.category,
      price: entity.price,
      imageUrl: entity.imageUrl,
      availability: entity.availability,
      duration: entity.duration,
      rating: entity.rating,
    );
  }

  ServiceEntity toEntity() {
    return ServiceEntity(
      id: id,
      name: name,
      category: category,
      price: price,
      imageUrl: imageUrl,
      availability: availability,
      duration: duration,
      rating: rating,
    );
  }
}
