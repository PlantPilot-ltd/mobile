import 'package:app/services/cache/models/cacheable_object.dart';

enum PlantTypeCacheModel {
  small,
  medium,
  large;

  factory PlantTypeCacheModel.fromString(String data) {
    switch (data) {
      case 'small':
        return PlantTypeCacheModel.small;
      case 'medium':
        return PlantTypeCacheModel.medium;
      case 'large':
        return PlantTypeCacheModel.large;
      default:
        return PlantTypeCacheModel.small;
    }
  }
}

class PlantCacheModel implements CacheableObject {
  @override
  int get key => id.hashCode;

  final String id;
  final String name;
  final String image;
  final PlantTypeCacheModel type;

  const PlantCacheModel({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
  });

  factory PlantCacheModel.fromMap(Map<String, Object?> map) {
    return PlantCacheModel(
      id: map['id'] as String,
      name: map['name'] as String,
      image: map['image'] as String,
      type: PlantTypeCacheModel.fromString(map['type'] as String),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'image': image,
    'type': type.name,
  };

  @override
  List<Object?> get props => [id, name, image, type];

  @override
  bool? get stringify => true;
}
