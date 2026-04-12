import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';

class DailyHelpDetailScreen extends StatelessWidget {
  const DailyHelpDetailScreen({required this.helpId, super.key});
  final String helpId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Help Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Card(child: Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: Column(children: [
              const CircleAvatar(radius: 40, backgroundColor: AppColors.surface, child: Icon(Icons.person_rounded, size: 40, color: AppColors.primary)),
              const SizedBox(height: AppSpacing.md),
              Text('Daily Help', style: AppTypography.headingMedium),
              Text('ID: $helpId', style: AppTypography.caption.copyWith(color: AppColors.grey500)),
            ]))),
            const SizedBox(height: AppSpacing.md),
            Card(child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Attendance Calendar', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.md),
              SizedBox(height: 200, child: Center(child: Text('Calendar heatmap will appear here', style: AppTypography.bodySmall.copyWith(color: AppColors.grey500)))),
            ]))),
            const SizedBox(height: AppSpacing.md),
            Card(child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Monthly Summary', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              _SummaryRow(label: 'Present Days', value: '—'),
              _SummaryRow(label: 'Absent Days', value: '—'),
              _SummaryRow(label: 'Total Days', value: '—'),
            ]))),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});
  final String label; final String value;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: AppTypography.bodyMedium), Text(value, style: AppTypography.titleMedium)]));
}
