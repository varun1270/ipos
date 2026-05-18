import '../dto/login_request_dto.dart';
import '../dto/otp_verify_request_dto.dart';
import '../dto/register_request_dto.dart';
import '../models/auth_token_model.dart';
import '../models/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokenModel> login(LoginRequestDto request);

  Future<AuthTokenModel> register(RegisterRequestDto request);

  Future<void> sendOtp(String phoneNumber);

  Future<AuthTokenModel> verifyOtp(OtpVerifyRequestDto request);

  Future<AuthUserModel> getCurrentUser(String accessToken);
}

class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<AuthTokenModel> login(LoginRequestDto request) async {
    return _mockToken();
  }

  @override
  Future<AuthTokenModel> register(RegisterRequestDto request) async {
    return _mockToken();
  }

  @override
  Future<void> sendOtp(String phoneNumber) async {}

  @override
  Future<AuthTokenModel> verifyOtp(OtpVerifyRequestDto request) async {
    return _mockToken();
  }

  @override
  Future<AuthUserModel> getCurrentUser(String accessToken) async {
    return const AuthUserModel(
      id: 'local-user',
      name: 'IPOS User',
      phoneNumber: '+91 98765 43210',
    );
  }

  AuthTokenModel _mockToken() {
    return AuthTokenModel(
      accessToken: 'mock-access-token',
      refreshToken: 'mock-refresh-token',
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );
  }
}
