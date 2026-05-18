import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../animations/auth_animations.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_brand_panel.dart';
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
    final isWide = context.isWideScreen;

    return Scaffold(
      body: AuthBackground(
        wideLayout: isWide,
        child: isWide ? _buildWideLayout(context) : _buildPhoneLayout(context),
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    final formMaxWidth = context.responsiveValue(
      compact: 420.0,
      medium: 440.0,
      expanded: 480.0,
    );
    final panelFlex = context.responsiveValue(compact: 5, medium: 5, expanded: 6);
    final formFlex = context.responsiveValue(compact: 6, medium: 6, expanded: 5);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: panelFlex,
          child: const AuthBrandPanel(),
        ),
        Expanded(
          flex: formFlex,
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsiveValue(
                  compact: 24,
                  medium: 32,
                  expanded: 48,
                ),
                vertical: 32,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: formMaxWidth),
                child: Material(
                  color: Colors.white.withValues(alpha: 0.96),
                  elevation: 16,
                  shadowColor: Colors.black.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(24),
                  child: Padding(
                    padding: EdgeInsets.all(
                      context.responsiveValue(
                        compact: 24,
                        medium: 28,
                        expanded: 32,
                      ),
                    ),
                    child: _OtpFormBody(
                      phoneNumber: widget.phoneNumber,
                      otpController: _otpController,
                      showLogo: false,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: _OtpFormBody(
        phoneNumber: widget.phoneNumber,
        otpController: _otpController,
        showLogo: true,
      ),
    );
  }
}

class _OtpFormBody extends ConsumerWidget {
  final String phoneNumber;
  final TextEditingController otpController;
  final bool showLogo;

  const _OtpFormBody({
    required this.phoneNumber,
    required this.otpController,
    required this.showLogo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(otpControllerProvider);
    final scale = context.layoutScale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showLogo) ...[
          const SizedBox(height: 36),
          AuthAnimations.fadeSlide(
            index: 0,
            child: AuthLogoSection(
              title: 'Verify OTP',
              subtitle: 'Enter the 6-digit code sent to $phoneNumber.',
              compact: false,
            ),
          ),
          const SizedBox(height: 32),
        ] else ...[
          AuthAnimations.fadeSlide(
            index: 0,
            child: _WideOtpHeader(
              phoneNumber: phoneNumber,
              scale: scale,
            ),
          ),
          SizedBox(height: 28 * scale),
        ],
        AuthAnimations.fadeSlide(
          index: 1,
          child: OtpInputField(controller: otpController),
        ),
        if (controller.errorMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            controller.errorMessage!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        const SizedBox(height: 24),
        AuthAnimations.fadeSlide(
          index: 2,
          child: AuthButton(
            text: 'Verify',
            isLoading: controller.isLoading,
            onPressed: () async {
              final success = await controller.verifyOtp(
                phoneNumber: phoneNumber,
                otp: otpController.text.trim(),
              );
              if (!context.mounted || !success) return;
              AppSnackbar.success(
                context,
                'OTP verified',
                title: 'You\'re all set',
                incoming: AppSnackbarAnimation.flip3D,
                outgoing: AppSnackbarAnimation.slideVertical,
                position: AppSnackbarPosition.top,
              );
              context.goNamed('login');
            },
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: controller.isLoading
                ? null
                : () => controller.resendOtp(phoneNumber: phoneNumber),
            child: const Text('Resend OTP'),
          ),
        ),
      ],
    );
  }
}

class _WideOtpHeader extends StatelessWidget {
  final String phoneNumber;
  final double scale;

  const _WideOtpHeader({required this.phoneNumber, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verify OTP',
          style: TextStyle(
            color: const Color(0xFF111827),
            fontSize: 32 * scale,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        SizedBox(height: 8 * scale),
        Text(
          'Enter the 6-digit code sent to $phoneNumber.',
          style: TextStyle(
            color: const Color(0xFF6B7280),
            fontSize: 15 * scale,
            fontWeight: FontWeight.w500,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
