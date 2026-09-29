/// Exceptions thrown from the data layer, caught by repositories and
/// mapped to a matching Failure.
class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Something went wrong. Please try again.']);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'No internet connection.']);
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Local storage error.']);
}