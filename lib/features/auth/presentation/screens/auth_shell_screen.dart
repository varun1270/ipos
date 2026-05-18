import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_divider.dart';
import '../widgets/auth_logo_section.dart';
import '../widgets/auth_tab_switcher.dart';
import '../widgets/auth_otp_link.dart';
import '../widgets/auth_phone_field.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_login_button.dart';

class AuthShellScreen extends ConsumerStatefulWidget {
  final int initialTab;

  const AuthShellScreen({super.key, this.initialTab = 0});

  @override
  ConsumerState<AuthShellScreen> createState() => _AuthShellScreenState();
}

class _AuthShellScreenState extends ConsumerState<AuthShellScreen> {
  late int _tabIndex;

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _registerPhoneController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  String _loginCountryCode = '+91';
  String _registerCountryCode = '+91';

  @override
  void initState() {
    super.initState();
    _tabIndex = widget.initialTab.clamp(0, 1);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _registerPhoneController.dispose();
    _registerPasswordController.dispose();
    super.dispose();
  }

  void _switchTab(int index) {
    if (index == _tabIndex) return;
    setState(() => _tabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = _tabIndex == 0;

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: isLogin ? 36 : 28),
              AuthLogoSection(
                title: isLogin ? 'Welcome back' : 'Create account',
                subtitle: isLogin
                    ? 'Login to manage your store and customers.'
                    : 'Set up your store workspace in minutes.',
              ),
              SizedBox(height: isLogin ? 32 : 28),
              AuthTabSwitcher(
                selectedIndex: _tabIndex,
                onChanged: _switchTab,
              ),
              const SizedBox(height: 24),
              IndexedStack(
                index: _tabIndex,
                sizing: StackFit.loose,
                children: [
                  _LoginForm(
                    phoneController: _phoneController,
                    passwordController: _passwordController,
                    countryCode: _loginCountryCode,
                    onCountryCodeChanged: (value) {
                      setState(() => _loginCountryCode = value);
                    },
                    phoneNumber: _loginPhoneNumber,
                  ),
                  _RegisterForm(
                    nameController: _nameController,
                    emailController: _emailController,
                    phoneController: _registerPhoneController,
                    passwordController: _registerPasswordController,
                    countryCode: _registerCountryCode,
                    onCountryCodeChanged: (value) {
                      setState(() => _registerCountryCode = value);
                    },
                    phoneNumber: _registerPhoneNumber,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _loginPhoneNumber {
    final phone = _phoneController.text.trim();
    return '$_loginCountryCode $phone';
  }

  String get _registerPhoneNumber {
    final phone = _registerPhoneController.text.trim();
    return '$_registerCountryCode $phone';
  }
}

class _LoginForm extends ConsumerWidget {
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final String countryCode;
  final ValueChanged<String> onCountryCodeChanged;
  final String phoneNumber;

  const _LoginForm({
    required this.phoneController,
    required this.passwordController,
    required this.countryCode,
    required this.onCountryCodeChanged,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(loginControllerProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthPhoneField(
          controller: phoneController,
          countryCode: countryCode,
          onCountryCodeChanged: onCountryCodeChanged,
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: passwordController,
          label: 'Password',
          hintText: 'Enter your password',
          icon: Icons.lock_rounded,
          obscureText: true,
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
          text: 'Login',
          isLoading: controller.isLoading,
          onPressed: () async {
            final success = await controller.login(
              phoneNumber: phoneNumber,
              password: passwordController.text.trim(),
            );
            if (!context.mounted || !success) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login successful')),
            );
          },
        ),
        const SizedBox(height: 12),
        AuthOtpLink(
          isLoading: controller.isLoading,
          onPressed: () async {
            final success = await controller.sendOtp(
              phoneNumber: phoneNumber,
            );
            if (!context.mounted || !success) return;
            context.goNamed(
              'otp',
              queryParameters: {'phone': phoneNumber},
            );
          },
        ),
        const SizedBox(height: 20),
        const AuthDivider(),
        const SizedBox(height: 16),
        const SocialLoginButton(
          icon: Icons.g_mobiledata_rounded,
          label: 'Continue with Google',
        ),
      ],
    );
  }
}

class _RegisterForm extends ConsumerWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final String countryCode;
  final ValueChanged<String> onCountryCodeChanged;
  final String phoneNumber;

  const _RegisterForm({
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.countryCode,
    required this.onCountryCodeChanged,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(registerControllerProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          controller: nameController,
          label: 'Full name',
          hintText: 'Your name',
          icon: Icons.person_rounded,
        ),
        const SizedBox(height: 14),
        AuthTextField(
          controller: emailController,
          label: 'Email',
          hintText: 'you@example.com',
          icon: Icons.email_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        AuthPhoneField(
          controller: phoneController,
          countryCode: countryCode,
          onCountryCodeChanged: onCountryCodeChanged,
        ),
        const SizedBox(height: 14),
        AuthTextField(
          controller: passwordController,
          label: 'Password',
          hintText: 'Create a password',
          icon: Icons.lock_rounded,
          obscureText: true,
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
              name: nameController.text.trim(),
              phoneNumber: phoneNumber,
              password: passwordController.text.trim(),
              email: emailController.text.trim().isEmpty
                  ? null
                  : emailController.text.trim(),
            );
            if (!context.mounted || !success) return;
            context.goNamed(
              'otp',
              queryParameters: {'phone': phoneNumber},
            );
          },
        ),
      ],
    );
  }
}
