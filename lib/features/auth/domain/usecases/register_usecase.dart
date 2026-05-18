import '../entities/auth_token_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  const RegisterUseCase(this.repository);

  Future<AuthTokenEntity> call({
    required String name,
    required String phoneNumber,
    required String password,
    String? email,
  }) {
    return repository.register(
      name: name,
      phoneNumber: phoneNumber,
      password: password,
      email: email,
    );
  }
}
