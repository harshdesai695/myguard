import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/auth/presentation/auth_routes.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_event.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_state.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
import 'package:myguard_frontend/shared/widgets/app_snackbar.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthLoginRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          final role = state.user.role;
          if (role == 'ROLE_ADMIN') {
            context.go('/admin');
          } else if (role == 'ROLE_GUARD') {
            context.go('/guard');
          } else {
            context.go('/resident');
          }
        } else if (state is AuthFailure) {
          AppSnackbar.error(context, message: state.message);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.xxl),
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppSpacing.md),
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        size: 40,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Center(
                    child: Text(
                      'Welcome Back',
                      style: AppTypography.displayMedium,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Center(
                    child: Text(
                      'Sign in to continue to MyGuard',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  AppTextField(
                    label: 'Email',
                    controller: _emailController,
                    hint: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    prefixIcon: const Icon(Icons.email_outlined, size: 20),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Password',
                    controller: _passwordController,
                    hint: 'Enter your password',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.password],
                    prefixIcon: const Icon(Icons.lock_outlined, size: 20),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                    onSubmitted: (_) => _onLogin(),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push(AuthRoutes.forgotPassword),
                      child: Text(
                        'Forgot Password?',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return AppButton(
                        label: 'Sign In',
                        onPressed: _onLogin,
                        isLoading: state is AuthLoading,
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.grey600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push(AuthRoutes.register),
                        child: Text(
                          'Register',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
