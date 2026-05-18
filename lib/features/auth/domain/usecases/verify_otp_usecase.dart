import '../entities/auth_token_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  const VerifyOtpUseCase(this.repository);

  Future<AuthTokenEntity> call({
    required String phoneNumber,
    required String otp,
  }) {
    return repository.verifyOtp(phoneNumber: phoneNumber, otp: otp);
  }
}
