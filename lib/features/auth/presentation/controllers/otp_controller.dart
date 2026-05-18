import 'package:flutter/foundation.dart';

import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';

class OtpController extends ChangeNotifier {
  final SendOtpUseCase _sendOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;

  OtpController({
    required SendOtpUseCase sendOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
  }) : _sendOtpUseCase = sendOtpUseCase,
       _verifyOtpUseCase = verifyOtpUseCase;

  bool isLoading = false;
  String? errorMessage;

  Future<bool> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    return _run(() {
      return _verifyOtpUseCase(phoneNumber: phoneNumber, otp: otp);
    });
  }

  Future<bool> resendOtp({required String phoneNumber}) async {
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
