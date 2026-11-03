import 'package:core/core.dart';

enum PlantTypeHttpModel {
  small,
  medium,
  large;

  static PlantTypeHttpModel fromString(String type) {
    switch (type) {
      case 'small':
        return PlantTypeHttpModel.small;
      case 'medium':
        return PlantTypeHttpModel.medium;
      case 'large':
        return PlantTypeHttpModel.large;
      default:
        throw AppException(message: 'Invalid plant type: $type');
    }
  }
}
