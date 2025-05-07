import 'package:hive/hive.dart';
import 'package:service_booking/domain/entities/service_entity.dart';

// part 'service_entity.g.dart';

@HiveType(typeId: 0)
class ServiceEntity extends HiveObject {
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
