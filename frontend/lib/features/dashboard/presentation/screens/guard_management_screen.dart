import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/user_management_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class GuardManagementScreen extends StatefulWidget {
  const GuardManagementScreen({super.key});

  @override
  State<GuardManagementScreen> createState() => _GuardManagementScreenState();
}

class _GuardManagementScreenState extends State<GuardManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserManagementCubit>().loadUsers(role: 'ROLE_GUARD');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guard Management')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/admin/users'),
        icon: const Icon(Icons.people_rounded),
        label: const Text('Manage Users'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: BlocBuilder<UserManagementCubit, UserManagementState>(
        builder: (context, state) {
          if (state is UserManagementLoading) {
            return const AppShimmerList();
          }
          if (state is UserManagementError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<UserManagementCubit>().loadUsers(role: 'ROLE_GUARD'),
            );
          }
          if (state is UsersLoaded) {
            final guards = state.users;
            if (guards.isEmpty) {
              return RefreshIndicator(
                onRefresh: () => context.read<UserManagementCubit>().loadUsers(role: 'ROLE_GUARD'),
                child: ListView(
                  children: const [
                    SizedBox(height: 200),
                    AppEmptyWidget(
                      message: 'No guards found.',
                      icon: Icons.security_outlined,
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () => context.read<UserManagementCubit>().loadUsers(role: 'ROLE_GUARD'),
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: guards.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final guard = guards[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        child: Text(
                          guard.name.isNotEmpty ? guard.name[0].toUpperCase() : 'G',
                          style: AppTypography.titleSmall.copyWith(color: AppColors.primary),
                        ),
                      ),
                      title: Text(guard.name, style: AppTypography.bodyMedium),
                      subtitle: Text(guard.phone, style: AppTypography.caption),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
                        decoration: BoxDecoration(
                          color: guard.isActive ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          guard.status,
                          style: AppTypography.caption.copyWith(
                            color: guard.isActive ? AppColors.success : AppColors.error,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
