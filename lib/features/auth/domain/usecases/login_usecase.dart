import '../entities/auth_token_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  Future<AuthTokenEntity> call({
    required String phoneNumber,
    required String password,
  }) {
    return repository.login(phoneNumber: phoneNumber, password: password);
  }
}
