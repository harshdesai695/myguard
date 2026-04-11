import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_event.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_state.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
import 'package:myguard_frontend/shared/widgets/app_snackbar.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedRole = 'ROLE_RESIDENT';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthRegisterRequested(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              phone: _phoneController.text.trim(),
              password: _passwordController.text,
              role: _selectedRole,
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
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create Account', style: AppTypography.displayMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Join your community on MyGuard',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppTextField(
                    label: 'Full Name',
                    controller: _nameController,
                    hint: 'Enter your full name',
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.person_outlined, size: 20),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Email',
                    controller: _emailController,
                    hint: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
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
                    label: 'Phone',
                    controller: _phoneController,
                    hint: 'Enter your phone number',
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Phone is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Role',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.grey700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment<String>(
                        value: 'ROLE_RESIDENT',
                        label: Text('Resident'),
                        icon: Icon(Icons.home_outlined),
                      ),
                      ButtonSegment<String>(
                        value: 'ROLE_GUARD',
                        label: Text('Guard'),
                        icon: Icon(Icons.security_outlined),
                      ),
                    ],
                    selected: {_selectedRole},
                    onSelectionChanged: (value) {
                      setState(() => _selectedRole = value.first);
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Password',
                    controller: _passwordController,
                    hint: 'Create a password',
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.lock_outlined, size: 20),
                    validator: (value) {
                      if (value == null || value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Confirm Password',
                    controller: _confirmPasswordController,
                    hint: 'Confirm your password',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    prefixIcon: const Icon(Icons.lock_outlined, size: 20),
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    onSubmitted: (_) => _onRegister(),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return AppButton(
                        label: 'Create Account',
                        onPressed: _onRegister,
                        isLoading: state is AuthLoading,
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.grey600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Text(
                          'Sign In',
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
