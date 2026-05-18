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
                    child: _AuthFormBody(
                      tabIndex: _tabIndex,
                      onTabChanged: _switchTab,
                      showLogo: false,
                      phoneController: _phoneController,
                      passwordController: _passwordController,
                      nameController: _nameController,
                      emailController: _emailController,
                      registerPhoneController: _registerPhoneController,
                      registerPasswordController:
                          _registerPasswordController,
                      loginCountryCode: _loginCountryCode,
                      registerCountryCode: _registerCountryCode,
                      onLoginCountryCodeChanged: (v) =>
                          setState(() => _loginCountryCode = v),
                      onRegisterCountryCodeChanged: (v) =>
                          setState(() => _registerCountryCode = v),
                      loginPhoneNumber: _loginPhoneNumber,
                      registerPhoneNumber: _registerPhoneNumber,
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
      child: _AuthFormBody(
        tabIndex: _tabIndex,
        onTabChanged: _switchTab,
        showLogo: true,
        phoneController: _phoneController,
        passwordController: _passwordController,
        nameController: _nameController,
        emailController: _emailController,
        registerPhoneController: _registerPhoneController,
        registerPasswordController: _registerPasswordController,
        loginCountryCode: _loginCountryCode,
        registerCountryCode: _registerCountryCode,
        onLoginCountryCodeChanged: (v) => setState(() => _loginCountryCode = v),
        onRegisterCountryCodeChanged: (v) =>
            setState(() => _registerCountryCode = v),
        loginPhoneNumber: _loginPhoneNumber,
        registerPhoneNumber: _registerPhoneNumber,
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

class _AuthFormBody extends StatelessWidget {
  final int tabIndex;
  final ValueChanged<int> onTabChanged;
  final bool showLogo;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController registerPhoneController;
  final TextEditingController registerPasswordController;
  final String loginCountryCode;
  final String registerCountryCode;
  final ValueChanged<String> onLoginCountryCodeChanged;
  final ValueChanged<String> onRegisterCountryCodeChanged;
  final String loginPhoneNumber;
  final String registerPhoneNumber;

  const _AuthFormBody({
    required this.tabIndex,
    required this.onTabChanged,
    required this.showLogo,
    required this.phoneController,
    required this.passwordController,
    required this.nameController,
    required this.emailController,
    required this.registerPhoneController,
    required this.registerPasswordController,
    required this.loginCountryCode,
    required this.registerCountryCode,
    required this.onLoginCountryCodeChanged,
    required this.onRegisterCountryCodeChanged,
    required this.loginPhoneNumber,
    required this.registerPhoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    final scale = context.layoutScale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showLogo) ...[
          const SizedBox(height: 36),
          AuthAnimations.fadeSlide(
            index: 0,
            child: const AuthLogoSection(
              title: 'Welcome to IPOS',
              subtitle: 'Sign in or create your store account to get started.',
              compact: false,
            ),
          ),
          const SizedBox(height: 32),
        ] else ...[
          AuthAnimations.fadeSlide(
            index: 0,
            child: _WideFormHeader(scale: scale),
          ),
          SizedBox(height: 28 * scale),
        ],
        AuthAnimations.fadeSlide(
          index: 1,
          child: AuthTabSwitcher(
            selectedIndex: tabIndex,
            onChanged: onTabChanged,
          ),
        ),
        SizedBox(height: 24 * scale),
        AuthAnimations.fadeSlide(
          index: 2,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            layoutBuilder: (currentChild, previousChildren) {
              return Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              );
            },
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: tabIndex == 0
                ? _LoginForm(
                    key: const ValueKey('login'),
                    phoneController: phoneController,
                    passwordController: passwordController,
                    countryCode: loginCountryCode,
                    onCountryCodeChanged: onLoginCountryCodeChanged,
                    phoneNumber: loginPhoneNumber,
                  )
                : _RegisterForm(
                    key: const ValueKey('register'),
                    nameController: nameController,
                    emailController: emailController,
                    phoneController: registerPhoneController,
                    passwordController: registerPasswordController,
                    countryCode: registerCountryCode,
                    onCountryCodeChanged: onRegisterCountryCodeChanged,
                    phoneNumber: registerPhoneNumber,
                  ),
          ),
        ),
      ],
    );
  }
}

class _WideFormHeader extends StatelessWidget {
  final double scale;

  const _WideFormHeader({required this.scale});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to IPOS',
          style: TextStyle(
            color: const Color(0xFF111827),
            fontSize: 32 * scale,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        SizedBox(height: 8 * scale),
        Text(
          'Sign in or create your store account to get started.',
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

class _LoginForm extends ConsumerWidget {
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final String countryCode;
  final ValueChanged<String> onCountryCodeChanged;
  final String phoneNumber;

  const _LoginForm({
    super.key,
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
            AppSnackbar.success(
              context,
              'Login successful',
              title: 'Welcome back',
              incoming: AppSnackbarAnimation.bounce,
              outgoing: AppSnackbarAnimation.fade,
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
    super.key,
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
