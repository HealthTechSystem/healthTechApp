import 'package:equatable/equatable.dart';

/// Core failure hierarchy used across the application for consistent error handling.
///
/// This sealed class pattern defines **domain-specific failures** that represent
/// different types of recoverable or reportable errors, ensuring every failure
/// carries a message and, optionally, a cause and stack trace.
///
/// ## 🎯 Purpose
/// - Unify error representation across layers (infra, use cases, presentation)
/// - Provide rich diagnostic info for logs (with `cause` and `stackTrace`)
/// - Enable `Equatable` comparison for easy testing and equality checks
///
/// ## 📐 Base Class
/// ```dart
/// sealed class Failure extends Equatable {
///   const Failure(this.message, {this.cause, this.stackTrace});
///   final String message;
///   final Object? cause;
///   final StackTrace? stackTrace;
///
///   @override
///   List<Object?> get props => [message, cause, stackTrace];
/// }
/// ```
///
/// ### Parameters
/// - `message` → Human-readable or localized error message
/// - `cause` → Optional underlying exception or object that triggered this failure
/// - `stackTrace` → Optional stack trace for debugging
///
/// ## ⚙️ Usage Example
///
/// ```dart
/// Future<void> fetchUser() async {
///   try {
///     final snapshot = await firestore.doc('users/123').get();
///     if (!snapshot.exists) throw const ValidationFailure('User not found');
///   } on FirebaseException catch (e, s) {
///     throw FirebaseFailure('Firebase error: ${e.code}', cause: e, stackTrace: s);
///   } on SocketException catch (e, s) {
///     throw NetworkFailure('No internet connection', cause: e, stackTrace: s);
///   }
/// }
/// ```
///
/// ## 🧪 Test Example
///
/// ```dart
/// test('equality works', () {
///   expect(
///     const ValidationFailure('invalid'),
///     equals(const ValidationFailure('invalid')),
///   );
/// });
/// ```
///
/// ## 🧭 Best Practices
/// - Always pass the original `stackTrace` when catching and rethrowing
/// - Prefer **domain-specific** subclasses (never throw `Failure` directly)
/// - When logging, include `failure.cause?.toString()` for better diagnostics
/// - Avoid catching `Failure` unless you're at the **presentation layer**
///
///
/// ## ✅ Quick Reference
///
/// ```dart
/// throw FirebaseFailure('Permission denied');
/// throw NetworkFailure('Timeout', cause: TimeoutException('...'));
/// throw StorageFailure('Failed to save file');
/// throw ValidationFailure('Invalid CPF');
/// ```
sealed class Failure extends Equatable {
  const Failure(this.message, {this.cause, this.stackTrace});
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [message, cause, stackTrace];
}

class FirebaseFailure extends Failure {
  const FirebaseFailure(super.message, {super.cause, super.stackTrace});
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

final class StorageFailure extends Failure {
  const StorageFailure(super.message, {super.cause, super.stackTrace});
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.cause, super.stackTrace});
}

class FakeFailure extends Failure {
  const FakeFailure(super.message, {super.cause, super.stackTrace});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.cause, super.stackTrace});
}
