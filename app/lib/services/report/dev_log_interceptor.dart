import 'dart:async';

import 'package:core/core.dart';
import 'package:http_interceptor/http_interceptor.dart';

class DevLoggingInterceptor implements HttpInterceptor {
  final LogService logger;

  DevLoggingInterceptor({required this.logger});

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    logger.logInfo('Server Request', request.toString());
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    logger.logInfo('Server Response', response.toString());
    return response;
  }

  @override
  FutureOr<bool> shouldInterceptRequest({required BaseRequest request}) => true;

  @override
  FutureOr<bool> shouldInterceptResponse({required BaseResponse response}) =>
      true;
}
