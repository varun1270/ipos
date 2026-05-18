import '../../domain/entities/auth_token_entity.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_local_datasource.dart';
import '../datasource/auth_remote_datasource.dart';
import '../dto/login_request_dto.dart';
import '../dto/otp_verify_request_dto.dart';
import '../dto/register_request_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<AuthTokenEntity> login({
    required String phoneNumber,
    required String password,
  }) async {
    final token = await remoteDataSource.login(
      LoginRequestDto(phoneNumber: phoneNumber, password: password),
    );
    await localDataSource.saveToken(token);
    return token;
  }

  @override
  Future<AuthTokenEntity> register({
    required String name,
    required String phoneNumber,
    required String password,
    String? email,
  }) async {
    final token = await remoteDataSource.register(
      RegisterRequestDto(
        name: name,
        phoneNumber: phoneNumber,
        password: password,
        email: email,
      ),
    );
    await localDataSource.saveToken(token);
    return token;
  }

  @override
  Future<void> sendOtp({required String phoneNumber}) {
    return remoteDataSource.sendOtp(phoneNumber);
  }

  @override
  Future<AuthTokenEntity> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    final token = await remoteDataSource.verifyOtp(
      OtpVerifyRequestDto(phoneNumber: phoneNumber, otp: otp),
    );
    await localDataSource.saveToken(token);
    return token;
  }

  @override
  Future<AuthUserEntity?> getCurrentUser() async {
    final token = await localDataSource.readToken();
    if (token == null || token.isExpired) return null;

    return remoteDataSource.getCurrentUser(token.accessToken);
  }

  @override
  Future<void> logout() {
    return localDataSource.clearToken();
  }
}
