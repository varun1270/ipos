import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../animations/auth_animations.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_logo_section.dart';
import '../widgets/auth_tab_switcher.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/country_code_picker.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String _countryCode = '+91';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(registerControllerProvider);

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 28),
              const AuthLogoSection(
                title: 'Create account',
                subtitle: 'Set up your store workspace in minutes.',
              ),
              const SizedBox(height: 28),
              AuthTabSwitcher(
                selectedIndex: 1,
                onChanged: (index) {
                  if (index == 0) context.pushReplacementNamed('login');
                },
              ),
              const SizedBox(height: 20),
              AuthAnimations.fadeSlide(
                index: 2,
                child: AuthTextField(
                  controller: _nameController,
                  label: 'Full name',
                  hintText: 'Your name',
                  icon: Icons.person_rounded,
                ),
              ),
              const SizedBox(height: 14),
              AuthAnimations.fadeSlide(
                index: 3,
                child: AuthTextField(
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'you@example.com',
                  icon: Icons.email_rounded,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 14),
              AuthAnimations.fadeSlide(
                index: 4,
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
              const SizedBox(height: 14),
              AuthAnimations.fadeSlide(
                index: 5,
                child: AuthTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hintText: 'Create a password',
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
              const SizedBox(height: 22),
              AuthButton(
                text: 'Register',
                isLoading: controller.isLoading,
                onPressed: () async {
                  final success = await controller.register(
                    name: _nameController.text.trim(),
                    phoneNumber: _phoneNumber,
                    password: _passwordController.text.trim(),
                    email: _emailController.text.trim().isEmpty
                        ? null
                        : _emailController.text.trim(),
                  );
                  if (!context.mounted || !success) return;
                  context.goNamed(
                    'otp',
                    queryParameters: {'phone': _phoneNumber},
                  );
                },
              ),
              const SizedBox(height: 18),
              AuthFooter(
                text: 'Already have an account?',
                actionText: 'Login',
                onTap: () => context.pushReplacementNamed('login'),
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
