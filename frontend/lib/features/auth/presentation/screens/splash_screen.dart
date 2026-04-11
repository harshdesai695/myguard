import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_event.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const AuthCheckRequested());
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
        } else if (state is AuthUnauthenticated || state is AuthFailure) {
          context.go('/auth/login');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.onPrimary,
                  borderRadius: BorderRadius.circular(AppSpacing.lg),
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'MyGuard',
                style: AppTypography.displayLarge.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Your Community, Secured',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
