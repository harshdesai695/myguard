import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/communication/presentation/bloc/notice_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class CommunityGroupListScreen extends StatefulWidget {
  const CommunityGroupListScreen({super.key});

  @override
  State<CommunityGroupListScreen> createState() => _CommunityGroupListScreenState();
}

class _CommunityGroupListScreenState extends State<CommunityGroupListScreen> {
  final List<_GroupItem> _groups = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    setState(() { _loading = true; _error = null; });
    // Groups will be loaded via communication datasource when wired
    // For now show empty state
    setState(() { _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Groups')),
      body: _loading
          ? const AppLoader()
          : _error != null
              ? AppErrorWidget(message: _error!, onRetry: _loadGroups)
              : _groups.isEmpty
                  ? const AppEmptyWidget(message: 'No groups available', icon: Icons.group_outlined)
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: _groups.length,
                      itemBuilder: (context, index) {
                        final group = _groups[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(AppSpacing.md),
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primaryLight.withValues(alpha: 0.1),
                              child: const Icon(Icons.group_rounded, color: AppColors.primary),
                            ),
                            title: Text(group.name, style: AppTypography.titleMedium),
                            subtitle: Text('${group.memberCount} members', style: AppTypography.bodySmall.copyWith(color: AppColors.grey600)),
                            trailing: group.unreadCount > 0
                                ? CircleAvatar(radius: 12, backgroundColor: AppColors.primary, child: Text('${group.unreadCount}', style: AppTypography.labelSmall.copyWith(color: AppColors.onPrimary)))
                                : const Icon(Icons.chevron_right_rounded),
                            onTap: () => context.push('/resident/groups/${group.id}'),
                          ),
                        );
                      },
                    ),
    );
  }
}

class _GroupItem {
  const _GroupItem({required this.id, required this.name, required this.memberCount, this.unreadCount = 0});
  final String id;
  final String name;
  final int memberCount;
  final int unreadCount;
}
