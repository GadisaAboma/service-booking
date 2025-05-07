// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_service_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveServiceModelAdapter extends TypeAdapter<HiveServiceModel> {
  @override
  final int typeId = 0;

  @override
  HiveServiceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveServiceModel(
      id: fields[0] as String?,
      name: fields[1] as String,
      category: fields[2] as String,
      price: fields[3] as double,
      imageUrl: fields[4] as String?,
      availability: fields[5] as bool,
      duration: fields[6] as int,
      rating: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, HiveServiceModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.availability)
      ..writeByte(6)
      ..write(obj.duration)
      ..writeByte(7)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveServiceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
