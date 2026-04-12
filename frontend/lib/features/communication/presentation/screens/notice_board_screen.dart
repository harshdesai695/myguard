import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/communication/presentation/bloc/notice_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class NoticeBoardScreen extends StatefulWidget {
  const NoticeBoardScreen({super.key});

  @override
  State<NoticeBoardScreen> createState() => _NoticeBoardScreenState();
}

class _NoticeBoardScreenState extends State<NoticeBoardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NoticeCubit>().loadNotices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notice Board')),
      body: BlocBuilder<NoticeCubit, NoticeState>(
        builder: (context, state) {
          if (state is NoticeLoading) return const AppShimmerList();
          if (state is NoticeError) return AppErrorWidget(message: state.message, onRetry: () => context.read<NoticeCubit>().loadNotices());
          if (state is NoticesLoaded) {
            if (state.notices.isEmpty) return const AppEmptyWidget(message: 'No notices yet', icon: Icons.campaign_outlined);
            return RefreshIndicator(
              onRefresh: () async => context.read<NoticeCubit>().loadNotices(),
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: state.notices.length,
                itemBuilder: (context, index) {
                  final notice = state.notices[index];
                  final typeColor = switch (notice.type) { 'URGENT' => AppColors.error, 'MAINTENANCE' => AppColors.warning, _ => AppColors.primary };
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: typeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                              child: Text(notice.type, style: AppTypography.labelSmall.copyWith(color: typeColor)),
                            ),
                            const Spacer(),
                            if (notice.postedAt != null) Text('${notice.postedAt!.day}/${notice.postedAt!.month}/${notice.postedAt!.year}', style: AppTypography.caption.copyWith(color: AppColors.grey500)),
                          ]),
                          const SizedBox(height: AppSpacing.sm),
                          Text(notice.title, style: AppTypography.titleMedium),
                          const SizedBox(height: AppSpacing.xs),
                          Text(notice.body, style: AppTypography.bodySmall.copyWith(color: AppColors.grey600), maxLines: 3, overflow: TextOverflow.ellipsis),
                        ],
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
