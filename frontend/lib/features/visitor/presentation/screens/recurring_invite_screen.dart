import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';

class RecurringInviteScreen extends StatelessWidget {
  const RecurringInviteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recurring Invites')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/resident/visitor/pre-approve'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.repeat_rounded, size: 64, color: AppColors.grey400),
              const SizedBox(height: AppSpacing.md),
              Text('Recurring Invites', style: AppTypography.titleLarge, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Recurring invites allow regular visitors (e.g., daily help, tutors) to enter without per-visit approval.\n\nTo create a recurring invite, go to Pre-Approve Visitor and enable the "Recurring" toggle.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                onPressed: () => context.push('/resident/visitor/pre-approve'),
                icon: const Icon(Icons.person_add_rounded),
                label: const Text('Go to Pre-Approve'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
