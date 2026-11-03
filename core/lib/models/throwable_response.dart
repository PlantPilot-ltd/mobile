part of '../core.dart';

// TODO: Remove, use try/catch
class ThrowableResponse<T> {
  final T? result;
  final Exception? failure;

  const ThrowableResponse._(this.result, this.failure);

  ThrowableResponse.success(T result) : this._(result, null);
  ThrowableResponse.failure(Exception failure) : this._(null, failure);

  bool get isFailed => failure != null;
  bool get isSuccess => failure == null;

  void handle({
    void Function(T result)? onSuccess,
    void Function(AppException e)? onFailure,
  }) {
    if (result != null) {
      onSuccess?.call(result as T);
    } else if (failure != null) {
      onFailure?.call(failure as AppException);
    }
  }
}

class VoidThrowableResponse extends ThrowableResponse<void> {
  const VoidThrowableResponse.success() : super._(null, null);
  const VoidThrowableResponse.failure(Exception failure)
    : super._(null, failure);
}
