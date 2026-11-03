import 'dart:convert';
import 'dart:typed_data';

import 'package:app/services/index.dart';
import 'package:core/core.dart';
import 'package:http/http.dart';

abstract class HttpService {
  final Client httpClient;
  final HttpServiceConfiguration configuration;

  const HttpService(this.httpClient, this.configuration);

  Future<ThrowableResponse<T>> makeRequest<T>(
    T Function(dynamic json) serializer,
    String url, {
    Map<String, dynamic>? queryParameters,
    Object? body,
    Map<String, String>? headers,
    required RequestType requestType,
    bool authorized = true,
    String? customToken,
    bool withTimeout = true,
    bool longTimeout = false,
    int? refreshTokenAttempts,
  }) async {
    final Uri uri = configuration.createServerUri(
      url,
      queryParameters: queryParameters,
    );
    final Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'content-type': 'application/json',
    };
    if (authorized) {
      if (customToken != null) {
        requestHeaders['Authorization'] = customToken;
      } else {
        final token = await configuration.getAuthorizationToken();
        if (token != null) {
          requestHeaders['Authorization'] = token;
        }
      }
    }
    if (headers != null) {
      requestHeaders.addAll(headers);
    }

    try {
      final encodedBody = jsonEncode(body);

      Response response;
      switch (requestType) {
        case RequestType.get:
          response = await httpClient.get(uri, headers: requestHeaders);
          break;
        case RequestType.post:
          response = await httpClient.post(
            uri,
            headers: requestHeaders,
            body: encodedBody,
          );
          break;
        case RequestType.put:
          response = await httpClient.put(
            uri,
            headers: requestHeaders,
            body: encodedBody,
          );
          break;
        case RequestType.delete:
          response = await httpClient.delete(
            uri,
            headers: requestHeaders,
            body: encodedBody,
          );
          break;
        case RequestType.patch:
          response = await httpClient.patch(
            uri,
            headers: requestHeaders,
            body: encodedBody,
          );
          break;
      }
      final AppException? responseException = AppNetworkException.fromResponse(
        response,
      );

      // Sign out if refresh token failed
      if (responseException is UnauthorizedException) {
        final unauthException = configuration.onUnauthorizedException(
          response,
          responseException,
        );
        if (unauthException != null) {
          return ThrowableResponse.failure(unauthException);
        }
      }

      final refreshAttempts =
          refreshTokenAttempts ?? configuration.refreshTokenAttempts;
      // Refresh token on UnauthorizedException
      if (responseException is UnauthorizedException && refreshAttempts > 0) {
        final isRefreshed = await configuration.refreshAuthorizationToken(
          response,
        );
        if (!isRefreshed) {
          return ThrowableResponse.failure(responseException);
        }
        return await makeRequest(
          serializer,
          url,
          queryParameters: queryParameters,
          body: body,
          headers: headers,
          requestType: requestType,
          authorized: authorized,
          customToken: customToken,
          withTimeout: withTimeout,
          longTimeout: longTimeout,
          refreshTokenAttempts: refreshAttempts - 1,
        );
      }
      if (responseException != null) {
        return ThrowableResponse.failure(responseException);
      }
      if (response.body.isEmpty) {
        return ThrowableResponse.success(serializer({}));
      }
      return ThrowableResponse.success(serializer(jsonDecode(response.body)));
    } catch (e, stackTrace) {
      return ThrowableResponse.failure(
        AppException.fromException(e, stackTrace),
      );
    }
  }

  Future<ThrowableResponse<bool>> uploadFile({
    required String uploadUrl,
    required Uint8List fileData,
    required String mimeType,
  }) async {
    try {
      final url = Uri.parse(uploadUrl);

      final response = await put(
        url,
        body: fileData,
        headers: {'Content-Type': mimeType},
      );
      final AppException? responseException = AppNetworkException.fromResponse(
        response,
      );

      if (responseException != null) {
        return ThrowableResponse.failure(responseException);
      }
      return ThrowableResponse.success(true);
    } catch (e, stackTrace) {
      return ThrowableResponse.failure(
        AppException.fromException(e, stackTrace),
      );
    }
  }
}
