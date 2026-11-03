import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AppNetworkException extends AppException {
  final String url;
  final int? serverCode;

  const AppNetworkException({
    required this.url,
    required this.serverCode,
    super.message = "Server exception",
    super.stackTrace,
    super.origin,
  });

  @override
  String toString() =>
      "${super.toString()}:\nURL: $url\nServer Code: ${serverCode ?? 'undefined'}";

  /// Parsing a response error from the server
  static AppException? fromResponse(http.Response response) {
    String serverMessage = "";
    try {
      if (response.bodyBytes.isNotEmpty && response.statusCode >= 400) {
        serverMessage = utf8.decode(response.bodyBytes);
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }

    return _fromResponseData(
      response.request?.url.toString() ?? "undefined url",
      response.statusCode,
      serverMessage,
    );
  }

  /// Parsing a response error from the server
  static AppException? _fromResponseData(
    String url,
    int statusCode,
    String? serverMessage,
  ) {
    switch (statusCode) {
      case 200:
      case 201:
      case 202:
        return null;
      default:
        break;
    }
    final message = (serverMessage?.isEmpty ?? true) ? null : serverMessage!;

    switch (statusCode) {
      case 401:
      case 403:
        return UnauthorizedException(
          url: url,
          serverCode: statusCode,
          message: message,
        );
      case 404:
        return AppNotFoundException(
          url: url,
          serverCode: statusCode,
          message: message,
        );
      case 429:
        return TooManyRequestsException(
          url: url,
          serverCode: statusCode,
          message: message,
        );
      default:
        break;
    }

    return AppCustomServerException(
      url: url,
      serverCode: statusCode,
      message: message,
    );
  }
}

class AppCustomServerException extends AppNetworkException {
  const AppCustomServerException({
    required super.url,
    required super.serverCode,
    super.message,
    super.stackTrace,
    super.origin,
  });
}

class AppNotFoundException extends AppNetworkException {
  const AppNotFoundException({
    required super.url,
    required super.serverCode,
    super.message = 'Not found',
    super.stackTrace,
    super.origin,
  });
}

class UnauthorizedException extends AppNetworkException {
  const UnauthorizedException({
    required super.url,
    required super.serverCode,
    super.message = 'Unauthorized',
    super.stackTrace,
    super.origin,
  });
}

class TooManyRequestsException extends AppNetworkException {
  const TooManyRequestsException({
    required super.url,
    required super.serverCode,
    super.message = 'Too many requests',
    super.stackTrace,
    super.origin,
  });
}
