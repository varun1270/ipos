import '../repositories/auth_repository.dart';

class SendOtpUseCase {
  final AuthRepository repository;

  const SendOtpUseCase(this.repository);

  Future<void> call({required String phoneNumber}) {
    return repository.sendOtp(phoneNumber: phoneNumber);
  }
}
