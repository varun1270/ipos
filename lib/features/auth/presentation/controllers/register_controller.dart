import 'package:flutter/foundation.dart';

import '../../domain/usecases/register_usecase.dart';

class RegisterController extends ChangeNotifier {
  final RegisterUseCase _registerUseCase;

  RegisterController({required RegisterUseCase registerUseCase})
    : _registerUseCase = registerUseCase;

  bool isLoading = false;
  String? errorMessage;

  Future<bool> register({
    required String name,
    required String phoneNumber,
    required String password,
    String? email,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _registerUseCase(
        name: name,
        phoneNumber: phoneNumber,
        password: password,
        email: email,
      );
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
