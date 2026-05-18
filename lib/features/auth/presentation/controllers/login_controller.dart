import 'package:flutter/foundation.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';

class LoginController extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final SendOtpUseCase _sendOtpUseCase;

  LoginController({
    required LoginUseCase loginUseCase,
    required SendOtpUseCase sendOtpUseCase,
  }) : _loginUseCase = loginUseCase,
       _sendOtpUseCase = sendOtpUseCase;

  bool isLoading = false;
  String? errorMessage;

  Future<bool> login({
    required String phoneNumber,
    required String password,
  }) async {
    return _run(() {
      return _loginUseCase(phoneNumber: phoneNumber, password: password);
    });
  }

  Future<bool> sendOtp({required String phoneNumber}) async {
    return _run(() {
      return _sendOtpUseCase(phoneNumber: phoneNumber);
    });
  }

  Future<bool> _run(Future<void> Function() action) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await action();
      return true;
    } catch (error) {
      errorMessage = error.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
