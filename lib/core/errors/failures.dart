// Failure types used across the domain layer (returned via Either<Failure, T>).
// TODO: define failure hierarchy (ServerFailure, CacheFailure, etc.).
abstract class Failure {}
