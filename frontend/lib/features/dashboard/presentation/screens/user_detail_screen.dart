import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/auth/domain/entities/user_entity.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/user_management_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';
import 'package:myguard_frontend/shared/widgets/app_snackbar.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({required this.uid, super.key});
  final String uid;

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserManagementCubit>().loadUserDetail(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Detail')),
      body: BlocConsumer<UserManagementCubit, UserManagementState>(
        listener: (context, state) {
          if (state is UserActionSuccess) {
            AppSnackbar.success(context, message: state.message);
            context.read<UserManagementCubit>().loadUserDetail(widget.uid);
          }
          if (state is UserManagementError) {
            AppSnackbar.error(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is UserManagementLoading) return const AppLoader();
          if (state is UserManagementError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<UserManagementCubit>().loadUserDetail(widget.uid),
            );
          }
          if (state is UserDetailLoaded) {
            return _buildDetail(context, state.user);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDetail(BuildContext context, UserEntity user) {
    final roleColor = switch (user.role) {
      'ROLE_ADMIN' => Colors.purple,
      'ROLE_GUARD' => AppColors.secondary,
      _ => AppColors.primary,
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          // Profile Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: roleColor.withValues(alpha: 0.1),
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: AppTypography.displaySmall.copyWith(color: roleColor),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(user.name, style: AppTypography.headingMedium),
                  Text(user.email, style: AppTypography.bodySmall.copyWith(color: AppColors.grey600)),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: roleColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppSpacing.xl)),
                        child: Text(user.role.replaceFirst('ROLE_', ''), style: AppTypography.labelMedium.copyWith(color: roleColor)),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: user.isActive ? AppColors.successLight : AppColors.errorLight,
                          borderRadius: BorderRadius.circular(AppSpacing.xl),
                        ),
                        child: Text(user.status, style: AppTypography.labelMedium.copyWith(color: user.isActive ? AppColors.success : AppColors.error)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Information', style: AppTypography.titleMedium),
                  const SizedBox(height: AppSpacing.md),
                  _InfoRow(label: 'Phone', value: user.phone),
                  _InfoRow(label: 'Flat', value: user.flatNumber ?? '—'),
                  _InfoRow(label: 'Society', value: user.societyId ?? '—'),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Actions Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Actions', style: AppTypography.titleMedium),
                  const SizedBox(height: AppSpacing.md),

                  // Change Role
                  Text('Change Role', style: AppTypography.labelMedium.copyWith(color: AppColors.grey700)),
                  const SizedBox(height: AppSpacing.xs),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'ROLE_RESIDENT', label: Text('Resident')),
                      ButtonSegment(value: 'ROLE_GUARD', label: Text('Guard')),
                      ButtonSegment(value: 'ROLE_ADMIN', label: Text('Admin')),
                    ],
                    selected: {user.role},
                    onSelectionChanged: (value) {
                      context.read<UserManagementCubit>().changeRole(user.uid, value.first);
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Activate/Deactivate
                  AppButton(
                    label: user.isActive ? 'Deactivate User' : 'Activate User',
                    onPressed: () {
                      context.read<UserManagementCubit>().changeStatus(
                        user.uid,
                        user.isActive ? 'DEACTIVATED' : 'ACTIVE',
                      );
                    },
                    variant: user.isActive ? AppButtonVariant.danger : AppButtonVariant.primary,
                    icon: user.isActive ? Icons.block_rounded : Icons.check_circle_rounded,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600)),
          Flexible(child: Text(value, style: AppTypography.bodyMedium, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
