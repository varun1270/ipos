import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../animations/auth_animations.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_divider.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_logo_section.dart';
import '../widgets/auth_tab_switcher.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/country_code_picker.dart';
import '../widgets/social_login_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String _countryCode = '+91';

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(loginControllerProvider);

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 36),
              const AuthLogoSection(
                title: 'Welcome back',
                subtitle: 'Login to manage your store and customers.',
              ),
              const SizedBox(height: 32),
              AuthTabSwitcher(
                selectedIndex: 0,
                onChanged: (index) {
                  if (index == 1) context.pushReplacementNamed('register');
                },
              ),
              const SizedBox(height: 24),
              AuthAnimations.fadeSlide(
                index: 2,
                child: AuthTextField(
                  controller: _phoneController,
                  label: 'Phone number',
                  hintText: '98765 43210',
                  icon: Icons.phone_rounded,
                  keyboardType: TextInputType.phone,
                  prefix: CountryCodePicker(
                    value: _countryCode,
                    onChanged: (value) {
                      setState(() => _countryCode = value);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AuthAnimations.fadeSlide(
                index: 3,
                child: AuthTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hintText: 'Enter your password',
                  icon: Icons.lock_rounded,
                  obscureText: true,
                ),
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
                index: 4,
                child: AuthButton(
                  text: 'Login',
                  isLoading: controller.isLoading,
                  onPressed: () async {
                    final success = await controller.login(
                      phoneNumber: _phoneNumber,
                      password: _passwordController.text.trim(),
                    );
                    if (!context.mounted || !success) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login successful')),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: controller.isLoading
                    ? null
                    : () async {
                        final success = await controller.sendOtp(
                          phoneNumber: _phoneNumber,
                        );
                        if (!context.mounted || !success) return;
                        context.goNamed(
                          'otp',
                          queryParameters: {'phone': _phoneNumber},
                        );
                      },
                child: const Text('Login with OTP'),
              ),
              const SizedBox(height: 20),
              const AuthDivider(),
              const SizedBox(height: 16),
              const SocialLoginButton(
                icon: Icons.g_mobiledata_rounded,
                label: 'Continue with Google',
              ),
              const SizedBox(height: 20),
              AuthFooter(
                text: "Don't have an account?",
                actionText: 'Register',
                onTap: () => context.pushReplacementNamed('register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _phoneNumber {
    final phone = _phoneController.text.trim();
    return '$_countryCode $phone';
  }
}
