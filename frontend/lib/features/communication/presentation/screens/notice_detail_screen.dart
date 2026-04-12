import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';

class NoticeDetailScreen extends StatelessWidget {
  const NoticeDetailScreen({required this.noticeId, super.key});
  final String noticeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notice')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(AppSpacing.md), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.primaryLight.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)), child: Text('GENERAL', style: AppTypography.labelSmall.copyWith(color: AppColors.primary))),
        const SizedBox(height: AppSpacing.sm),
        Text('Notice Title', style: AppTypography.headingMedium),
        const SizedBox(height: AppSpacing.xs),
        Text('Posted on —', style: AppTypography.caption.copyWith(color: AppColors.grey500)),
        const SizedBox(height: AppSpacing.lg),
        Text('Notice content will be loaded from the API.\n\nID: $noticeId', style: AppTypography.bodyMedium.copyWith(color: AppColors.grey700, height: 1.6)),
      ])),
    );
  }
}
