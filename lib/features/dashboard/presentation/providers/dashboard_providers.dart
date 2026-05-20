// Riverpod provider wiring for the dashboard feature.
// Exposes providers for the repository, each use case, and the four
// controllers (dashboard, date range filter, shop selector, revenue chart)
// so screens and widgets can read them without manual plumbing.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/dashboard_local_datasource.dart';
import '../../data/datasource/dashboard_remote_datasource.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/dashboard_usecase.dart';

final dashboardRemoteDataSourceProvider = Provider<DashboardRemoteDataSource>((ref) {
  return MockAuthRemoteDataSource();
});

final dashboardLocalDataSourceProvider = Provider<DashboardLocalDataSource>((ref) {
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
