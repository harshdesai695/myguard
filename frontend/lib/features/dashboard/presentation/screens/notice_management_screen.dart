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

import 'package:myguard_frontend/shared/widgets/app_snackbar.dart';

class NoticeManagementScreen extends StatefulWidget {
  const NoticeManagementScreen({super.key});

  @override
  State<NoticeManagementScreen> createState() => _NoticeManagementScreenState();
}

class _NoticeManagementScreenState extends State<NoticeManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NoticeCubit>().loadNotices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notice Management')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/admin/notices/create'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create Notice'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: BlocConsumer<NoticeCubit, NoticeState>(
        listener: (context, state) {
          if (state is NoticeActionSuccess) {
            AppSnackbar.success(context, message: state.message);
            context.read<NoticeCubit>().loadNotices();
          } else if (state is NoticeError) {
            AppSnackbar.error(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is NoticeLoading) return const AppShimmerList();
          if (state is NoticeError) {
            return AppErrorWidget(message: state.message, onRetry: () => context.read<NoticeCubit>().loadNotices());
          }
          if (state is NoticesLoaded) {
            if (state.notices.isEmpty) {
              return const AppEmptyWidget(message: 'No notices yet.\nTap + to create one.', icon: Icons.campaign_outlined);
            }
            return RefreshIndicator(
              onRefresh: () async => context.read<NoticeCubit>().loadNotices(),
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: state.notices.length,
                itemBuilder: (context, index) {
                  final notice = state.notices[index];
                  final typeColor = switch (notice.type) {
                    'URGENT' => AppColors.error,
                    'MAINTENANCE' => AppColors.warning,
                    _ => AppColors.primary,
                  };
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(AppSpacing.md),
                      title: Text(notice.title, style: AppTypography.titleMedium),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppSpacing.xxs),
                          Text(notice.body, style: AppTypography.bodySmall.copyWith(color: AppColors.grey600), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: AppSpacing.xs),
                          Row(children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: typeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                              child: Text(notice.type, style: AppTypography.labelSmall.copyWith(color: typeColor)),
                            ),
                            const Spacer(),
                            if (notice.postedAt != null) Text('${notice.postedAt!.day}/${notice.postedAt!.month}/${notice.postedAt!.year}', style: AppTypography.caption.copyWith(color: AppColors.grey500)),
                          ]),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                        onPressed: () => _confirmDelete(context, notice.id, notice.title),
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

  void _confirmDelete(BuildContext context, String id, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Notice?'),
        content: Text('Are you sure you want to delete "$title"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<NoticeCubit>().deleteNotice(id);
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
