import '../entities/auth_token_entity.dart';
import '../entities/auth_user_entity.dart';

abstract class AuthRepository {
  Future<AuthTokenEntity> login({
    required String phoneNumber,
    required String password,
  });

  Future<AuthTokenEntity> register({
    required String name,
    required String phoneNumber,
    required String password,
    String? email,
  });

  Future<void> sendOtp({required String phoneNumber});

  Future<AuthTokenEntity> verifyOtp({
    required String phoneNumber,
    required String otp,
  });

  Future<AuthUserEntity?> getCurrentUser();

  Future<void> logout();
}
