import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';

class PanicAlertsScreen extends StatelessWidget {
  const PanicAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panic Alerts')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, size: 64, color: AppColors.success),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('All Clear', style: AppTypography.headingMedium),
            const SizedBox(height: AppSpacing.xs),
            Text('No active panic alerts', style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600)),
          ],
        ),
      ),
    );
  }
}
