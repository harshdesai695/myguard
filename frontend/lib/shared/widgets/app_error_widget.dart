import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    required this.message,
    super.key,
    this.onRetry,
    this.icon,
  });

  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.error_outline_rounded,
              size: 64,
              color: AppColors.grey400,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Retry',
                onPressed: onRetry,
                variant: AppButtonVariant.outline,
                isFullWidth: false,
                size: AppButtonSize.small,
                icon: Icons.refresh_rounded,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
