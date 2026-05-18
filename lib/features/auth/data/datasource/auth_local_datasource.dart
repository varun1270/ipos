import '../models/auth_token_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(AuthTokenModel token);

  Future<AuthTokenModel?> readToken();

  Future<void> clearToken();
}

class InMemoryAuthLocalDataSource implements AuthLocalDataSource {
  AuthTokenModel? _token;

  @override
  Future<void> saveToken(AuthTokenModel token) async {
    _token = token;
  }

  @override
  Future<AuthTokenModel?> readToken() async {
    return _token;
  }

  @override
  Future<void> clearToken() async {
    _token = null;
  }
}
