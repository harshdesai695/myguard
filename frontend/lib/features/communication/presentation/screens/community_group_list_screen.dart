import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/communication/presentation/bloc/community_group_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class CommunityGroupListScreen extends StatefulWidget {
  const CommunityGroupListScreen({super.key});

  @override
  State<CommunityGroupListScreen> createState() => _CommunityGroupListScreenState();
}

class _CommunityGroupListScreenState extends State<CommunityGroupListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CommunityGroupCubit>().loadGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Groups')),
      body: BlocBuilder<CommunityGroupCubit, GroupState>(
        builder: (context, state) {
          if (state is GroupLoading) return const AppShimmerList();
          if (state is GroupError) {
            return AppErrorWidget(message: state.message, onRetry: () => context.read<CommunityGroupCubit>().loadGroups());
          }
          if (state is GroupsLoaded) {
            if (state.groups.isEmpty) {
              return const AppEmptyWidget(message: 'No groups available', icon: Icons.group_outlined);
            }
            return RefreshIndicator(
              onRefresh: () async => context.read<CommunityGroupCubit>().loadGroups(),
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: state.groups.length,
                itemBuilder: (context, index) {
                  final group = state.groups[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(AppSpacing.md),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryLight.withValues(alpha: 0.1),
                        child: const Icon(Icons.group_rounded, color: AppColors.primary),
                      ),
                      title: Text(group.name, style: AppTypography.titleMedium),
                      subtitle: Text('${group.memberUids?.length ?? 0} members', style: AppTypography.bodySmall.copyWith(color: AppColors.grey600)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.push('/resident/groups/${group.id}'),
                    ),
                  );
                },
              ),
            );
          }
          return const AppEmptyWidget(message: 'No groups available', icon: Icons.group_outlined);
        },
      ),
    );
  }
}
