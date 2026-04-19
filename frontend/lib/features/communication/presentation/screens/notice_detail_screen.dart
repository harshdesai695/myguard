import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/communication/presentation/bloc/notice_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class NoticeDetailScreen extends StatefulWidget {
  const NoticeDetailScreen({required this.noticeId, super.key});
  final String noticeId;

  @override
  State<NoticeDetailScreen> createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends State<NoticeDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NoticeCubit>().loadNotices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notice')),
      body: BlocBuilder<NoticeCubit, NoticeState>(
        builder: (context, state) {
          if (state is NoticeLoading) return const AppShimmerList(itemCount: 3, itemHeight: 60);
          if (state is NoticeError) return AppErrorWidget(message: state.message, onRetry: () => context.read<NoticeCubit>().loadNotices());
          if (state is NoticesLoaded) {
            final notice = state.notices.where((n) => n.id == widget.noticeId).firstOrNull;
            if (notice == null) return const Center(child: Text('Notice not found'));
            final typeColor = switch (notice.type) { 'URGENT' => AppColors.error, 'MAINTENANCE' => AppColors.warning, _ => AppColors.primary };
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: typeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                  child: Text(notice.type, style: AppTypography.labelSmall.copyWith(color: typeColor)),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(notice.title, style: AppTypography.headingMedium),
                const SizedBox(height: AppSpacing.xs),
                if (notice.postedAt != null)
                  Text('Posted on ${notice.postedAt!.day}/${notice.postedAt!.month}/${notice.postedAt!.year}', style: AppTypography.caption.copyWith(color: AppColors.grey500)),
                const SizedBox(height: AppSpacing.lg),
                Text(notice.body, style: AppTypography.bodyMedium.copyWith(color: AppColors.grey700, height: 1.6)),
              ]),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
