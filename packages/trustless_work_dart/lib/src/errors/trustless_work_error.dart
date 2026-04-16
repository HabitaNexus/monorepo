/// Base error hierarchy for all Trustless Work SDK failures.
///
/// Use pattern matching on `switch` for exhaustive handling:
/// ```dart
/// switch (error) {
///   case BadRequest(): ...
///   case Unauthorized(): ...
///   case TooManyRequests(): ...
///   case ServerError(): ...
///   case NetworkError(): ...
///   case SigningError(): ...
/// }
/// ```
sealed class TrustlessWorkError implements Exception {
  const TrustlessWorkError._(this.message);

  final String message;

  int? get statusCode;

  const factory TrustlessWorkError.badRequest({required String message}) = BadRequest;
  const factory TrustlessWorkError.unauthorized({required String message}) = Unauthorized;
  const factory TrustlessWorkError.tooManyRequests({required String message}) = TooManyRequests;
  const factory TrustlessWorkError.serverError({
    required String message,
    List<String> possibleCauses,
  }) = ServerError;
  const factory TrustlessWorkError.network({
    required String message,
    Object? cause,
  }) = NetworkError;
  const factory TrustlessWorkError.signing({
    required String message,
    Object? cause,
  }) = SigningError;

  @override
  String toString() => '$runtimeType: $message';
}

final class BadRequest extends TrustlessWorkError {
  const BadRequest({required String message}) : super._(message);
  @override
  int get statusCode => 400;
}

final class Unauthorized extends TrustlessWorkError {
  const Unauthorized({required String message}) : super._(message);
  @override
  int get statusCode => 401;
}

final class TooManyRequests extends TrustlessWorkError {
  const TooManyRequests({required String message}) : super._(message);
  @override
  int get statusCode => 429;
}

final class ServerError extends TrustlessWorkError {
  const ServerError({
    required String message,
    this.possibleCauses = const [],
  }) : super._(message);
  final List<String> possibleCauses;
  @override
  int get statusCode => 500;
}

final class NetworkError extends TrustlessWorkError {
  const NetworkError({required String message, this.cause}) : super._(message);
  final Object? cause;
  @override
  int? get statusCode => null;
}

final class SigningError extends TrustlessWorkError {
  const SigningError({required String message, this.cause}) : super._(message);
  final Object? cause;
  @override
  int? get statusCode => null;
}
