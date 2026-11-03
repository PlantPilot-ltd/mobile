import 'package:app/services/index.dart';

class GreenhouseCacheModel implements CacheableObject {
  @override
  int get key => remoteId.hashCode;

  final String remoteId;
  final String name;
  final List<PlantCacheModel> plants;

  const GreenhouseCacheModel({
    required this.remoteId,
    required this.name,
    required this.plants,
  });

  factory GreenhouseCacheModel.fromMap(Map<String, Object?> map) {
    return GreenhouseCacheModel(
      remoteId: map['remoteId'] as String,
      name: map['name'] as String,
      plants: (map['plants'] as List<dynamic>)
          .map((e) => PlantCacheModel.fromMap(e as Map<String, Object?>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
    'remoteId': remoteId,
    'name': name,
    'plants': plants.map((e) => e.toMap()).toList(),
  };

  @override
  List<Object?> get props => [remoteId, name, plants];

  @override
  bool? get stringify => true;
}
