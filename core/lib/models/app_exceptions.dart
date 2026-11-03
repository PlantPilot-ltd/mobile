part of '../core.dart';

/// The model describes a custom application error
class AppException implements Exception {
  final String? message;
  final StackTrace? stackTrace;
  final Object? origin;

  /// Should report exception to Sentry
  bool get reportable => false;

  /// Should log exception to console
  bool get loggable => true;

  const AppException({this.message, this.stackTrace, this.origin});

  @override
  String toString() {
    String response = '[${runtimeType.toString()}] exception';
    if (message != null) {
      response = '$response\nCustom message: $message';
    }
    if (stackTrace != null) {
      response = '$response\nStackTrace: ${stackTrace!.toString()}';
    }
    if (origin != null) {
      if (origin is Error) {
        response = '$response\nOrigin error: ${origin!.toString()}';
        if ((origin as Error).stackTrace != null) {
          response =
              '$response\nOrigin stackTrace: ${(origin as Error).stackTrace!.toString()}';
        }
      } else {
        response = '$response\nOrigin: ${origin!.toString()}';
      }
    }
    return response;
  }

  /// Return error from system exception
  static AppException fromException(Object e, StackTrace stackTrace) =>
      switch (e) {
        AppException() => e,
        FormatException() => AppFormatException(
          message: e.message,
          stackTrace: stackTrace,
          origin: e,
        ),
        _ => AppUndefinedException(stackTrace: stackTrace, origin: e),
      };
}

class AppUndefinedException extends AppException {
  const AppUndefinedException({
    super.message = "Unexpected error",
    super.stackTrace,
    super.origin,
  });

  @override
  bool get reportable => true;
}

class AppFormatException extends AppException {
  const AppFormatException({
    super.message = "Format exception",
    super.stackTrace,
    super.origin,
  });

  @override
  bool get reportable => true;
}
