import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../animations/auth_animations.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_logo_section.dart';
import '../widgets/otp_input_field.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(otpControllerProvider);

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 56),
              AuthAnimations.fadeSlide(
                child: AuthLogoSection(
                  title: 'Verify OTP',
                  subtitle:
                      'Enter the 6-digit code sent to ${widget.phoneNumber}.',
                ),
              ),
              const SizedBox(height: 32),
              AuthAnimations.fadeSlide(
                index: 1,
                child: OtpInputField(controller: _otpController),
              ),
              if (controller.errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  controller.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 24),
              AuthButton(
                text: 'Verify',
                isLoading: controller.isLoading,
                onPressed: () async {
                  final success = await controller.verifyOtp(
                    phoneNumber: widget.phoneNumber,
                    otp: _otpController.text.trim(),
                  );
                  if (!context.mounted || !success) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('OTP verified')));
                  context.goNamed('login');
                },
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: controller.isLoading
                    ? null
                    : () =>
                          controller.resendOtp(phoneNumber: widget.phoneNumber),
                child: const Text('Resend OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
