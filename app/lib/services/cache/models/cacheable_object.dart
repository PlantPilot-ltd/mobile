import 'package:equatable/equatable.dart';

mixin CacheableObject on Equatable {
  int get key;

  Map<String, Object?> toMap();
}
