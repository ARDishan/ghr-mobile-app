import 'package:equatable/equatable.dart';

/// Failure types returned from the domain layer as `Either<Failure, T>`.
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Supabase/API call failed (network reachable, server returned an error).
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong. Please try again.']);
}

/// No network connectivity.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

/// Authentication-specific failure (invalid OTP, expired OTP, not a customer, etc.).
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Local cache/storage failure.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage error.']);
}
