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

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _roles = ['ROLE_RESIDENT', 'ROLE_GUARD', 'ROLE_ADMIN'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<UserManagementCubit>().loadUsers(role: _roles[_tabController.index]);
      }
    });
    context.read<UserManagementCubit>().loadUsers(role: 'ROLE_RESIDENT');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Residents'), Tab(text: 'Guards'), Tab(text: 'Admins')],
        ),
      ),
      body: BlocConsumer<UserManagementCubit, UserManagementState>(
        listener: (context, state) {
          if (state is UserActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            context.read<UserManagementCubit>().loadUsers(role: _roles[_tabController.index]);
          }
        },
        builder: (context, state) {
          if (state is UserManagementLoading) return const AppShimmerList();
          if (state is UserManagementError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<UserManagementCubit>().loadUsers(role: _roles[_tabController.index]),
            );
          }
          if (state is UsersLoaded) {
            if (state.users.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async => context.read<UserManagementCubit>().loadUsers(role: _roles[_tabController.index]),
                child: ListView(children: const [
                  SizedBox(height: 200),
                  AppEmptyWidget(message: 'No users found', icon: Icons.people_outlined),
                ]),
              );
            }
            return RefreshIndicator(
              onRefresh: () async => context.read<UserManagementCubit>().loadUsers(role: _roles[_tabController.index]),
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  final roleColor = switch (user.role) {
                    'ROLE_ADMIN' => Colors.purple,
                    'ROLE_GUARD' => AppColors.secondary,
                    _ => AppColors.primary,
                  };
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(AppSpacing.md),
                      leading: CircleAvatar(
                        backgroundColor: roleColor.withValues(alpha: 0.1),
                        child: Text(
                          user.name[0].toUpperCase(),
                          style: AppTypography.titleMedium.copyWith(color: roleColor),
                        ),
                      ),
                      title: Text(user.name, style: AppTypography.titleMedium),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.email, style: AppTypography.bodySmall.copyWith(color: AppColors.grey600)),
                          const SizedBox(height: AppSpacing.xxs),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: roleColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  user.role.replaceFirst('ROLE_', ''),
                                  style: AppTypography.labelSmall.copyWith(color: roleColor, fontSize: 9),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: user.isActive ? AppColors.successLight : AppColors.errorLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  user.status,
                                  style: AppTypography.labelSmall.copyWith(
                                    color: user.isActive ? AppColors.success : AppColors.error,
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.grey400),
                      onTap: () => context.push('/admin/users/${user.uid}'),
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
