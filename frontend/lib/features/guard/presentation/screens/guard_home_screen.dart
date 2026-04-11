import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';

class GuardHomeScreen extends StatelessWidget {
  const GuardHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Guard Dashboard', style: AppTypography.headingLarge),
              const SizedBox(height: AppSpacing.lg),
              _StatCard(icon: Icons.people_outline, label: 'Pending Entries', value: '0', color: AppColors.warning),
              const SizedBox(height: AppSpacing.sm),
              _StatCard(icon: Icons.shield_outlined, label: 'Patrol Status', value: 'Not Started', color: AppColors.info),
              const SizedBox(height: AppSpacing.sm),
              _StatCard(icon: Icons.access_time, label: 'Shift', value: 'Active', color: AppColors.success),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.label, required this.value, required this.color});
  final IconData icon; final String label; final String value; final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppSpacing.sm)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.grey600)),
              Text(value, style: AppTypography.titleMedium),
            ]),
          ],
        ),
      ),
    );
  }
}
