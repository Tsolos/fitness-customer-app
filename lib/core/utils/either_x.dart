import 'package:dartz/dartz.dart';

/// Bridges the domain layer's `Either<Failure, T>` to Riverpod's
/// `AsyncValue`: unwrap with [getOrThrow] inside a `@riverpod` function so
/// a `Left(failure)` surfaces as `AsyncError(failure)` and the UI can
/// pattern-match on `error is Failure`.
extension EitherFutureX<L extends Object, R> on Future<Either<L, R>> {
  Future<R> getOrThrow() async {
    final either = await this;
    return either.fold((l) => throw l, (r) => r);
  }

  /// For "fire an action, show its failure if any" call sites: collapses
  /// `Either<Failure, T>` to `Failure?` (null on success).
  Future<L?> failureOrNull() async {
    final either = await this;
    return either.fold((l) => l, (r) => null);
  }
}
