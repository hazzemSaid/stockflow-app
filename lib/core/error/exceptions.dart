class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server Exception']);
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Authentication Exception']);
}

class GoogleSignInCancelledException implements Exception {
  const GoogleSignInCancelledException();
}
