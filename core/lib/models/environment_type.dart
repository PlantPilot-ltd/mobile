part of '../core.dart';

enum EnvironmentType { development, production, mock }

extension EnvironmentTypeParser on EnvironmentType {
  static EnvironmentType fromString(String type) => switch (type) {
    "prod" => .production,
    "dev" => .development,
    "mock" => .mock,
    _ => .mock,
  };

  String get name => switch (this) {
    .development => "dev",
    .production => "prod",
    .mock => "mock",
  };
}
