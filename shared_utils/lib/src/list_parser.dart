abstract final class ListParser {
  static List<T> parse<T>(
    dynamic json,
    T Function(dynamic) parser, {
    bool allowNull = true,
  }) {
    if (json == null && allowNull) return <T>[];
    if (json is! List) throw const FormatException('Expected array');
    return json.map(parser).toList();
  }

  static List<T> parseIgnoring<T>(dynamic json, T Function(dynamic) parser) {
    final result = <T>[];
    if (json is! List) return result;
    for (final item in json) {
      try {
        result.add(parser(item));
      } catch (_) {}
    }
    return result;
  }
}
