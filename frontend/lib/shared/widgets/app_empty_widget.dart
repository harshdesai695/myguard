import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';

class AppEmptyWidget extends StatelessWidget {
  const AppEmptyWidget({
    required this.message,
    super.key,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.inbox_rounded,
              size: 80,
              color: AppColors.grey300,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                variant: AppButtonVariant.primary,
                isFullWidth: false,
                size: AppButtonSize.small,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
