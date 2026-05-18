import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/auth_local_datasource.dart';
import '../../data/datasource/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../controllers/login_controller.dart';
import '../controllers/otp_controller.dart';
import '../controllers/register_controller.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return MockAuthRemoteDataSource();
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return InMemoryAuthLocalDataSource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
});

final sendOtpUseCaseProvider = Provider<SendOtpUseCase>((ref) {
  return SendOtpUseCase(ref.watch(authRepositoryProvider));
});

final verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>((ref) {
  return VerifyOtpUseCase(ref.watch(authRepositoryProvider));
});

final loginControllerProvider =
    ChangeNotifierProvider.autoDispose<LoginController>((ref) {
      return LoginController(
        loginUseCase: ref.watch(loginUseCaseProvider),
        sendOtpUseCase: ref.watch(sendOtpUseCaseProvider),
      );
    });

final registerControllerProvider =
    ChangeNotifierProvider.autoDispose<RegisterController>((ref) {
      return RegisterController(
        registerUseCase: ref.watch(registerUseCaseProvider),
      );
    });

final otpControllerProvider = ChangeNotifierProvider.autoDispose<OtpController>(
  (ref) {
    return OtpController(
      sendOtpUseCase: ref.watch(sendOtpUseCaseProvider),
      verifyOtpUseCase: ref.watch(verifyOtpUseCaseProvider),
    );
  },
);
