/// A sum type for operations that may fail with a typed error.
///
/// Prefer this over throwing when you want callers to handle errors
/// without try/catch — the exhaustive `switch` on the sealed hierarchy
/// forces them to account for both branches.
sealed class Result<T, E> {
  const Result();

  const factory Result.ok(T value) = Ok<T, E>;
  const factory Result.err(E error) = Err<T, E>;

  bool get isOk => this is Ok<T, E>;
  bool get isErr => this is Err<T, E>;

  T? get valueOrNull => switch (this) {
        Ok<T, E>(value: final v) => v,
        Err<T, E>() => null,
      };

  E? get errorOrNull => switch (this) {
        Ok<T, E>() => null,
        Err<T, E>(error: final e) => e,
      };

  Result<U, E> map<U>(U Function(T) transform) => switch (this) {
        Ok<T, E>(value: final v) => Result.ok(transform(v)),
        Err<T, E>(error: final e) => Result.err(e),
      };

  R when<R>({required R Function(T) ok, required R Function(E) err}) =>
      switch (this) {
        Ok<T, E>(value: final v) => ok(v),
        Err<T, E>(error: final e) => err(e),
      };
}

final class Ok<T, E> extends Result<T, E> {
  const Ok(this.value);
  final T value;
}

final class Err<T, E> extends Result<T, E> {
  const Err(this.error);
  final E error;
}
