import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_radius.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';

enum AppButtonVariant { primary, secondary, outline, text, danger }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.prefixIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final height = switch (size) {
      AppButtonSize.small => 36.0,
      AppButtonSize.medium => 48.0,
      AppButtonSize.large => 56.0,
    };

    final textStyle = switch (size) {
      AppButtonSize.small => AppTypography.buttonSmall,
      AppButtonSize.medium => AppTypography.buttonMedium,
      AppButtonSize.large => AppTypography.buttonLarge,
    };

    final padding = switch (size) {
      AppButtonSize.small => const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      AppButtonSize.medium => const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      AppButtonSize.large => const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
    };

    final child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _foregroundColor,
            ),
          )
        : Row(
            mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixIcon != null) ...[
                prefixIcon!,
                const SizedBox(width: AppSpacing.sm),
              ],
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(label, style: textStyle),
            ],
          );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: switch (variant) {
        AppButtonVariant.primary => ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: padding,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.borderRadiusMd,
              ),
              elevation: 0,
            ),
            child: child,
          ),
        AppButtonVariant.secondary => ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLight.withValues(alpha: 0.1),
              foregroundColor: AppColors.primary,
              padding: padding,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.borderRadiusMd,
              ),
              elevation: 0,
            ),
            child: child,
          ),
        AppButtonVariant.outline => OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: padding,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.borderRadiusMd,
              ),
              side: const BorderSide(color: AppColors.primary),
            ),
            child: child,
          ),
        AppButtonVariant.text => TextButton(
            onPressed: isLoading ? null : onPressed,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: padding,
            ),
            child: child,
          ),
        AppButtonVariant.danger => ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.onError,
              padding: padding,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.borderRadiusMd,
              ),
              elevation: 0,
            ),
            child: child,
          ),
      },
    );
  }

  Color get _foregroundColor => switch (variant) {
        AppButtonVariant.primary => AppColors.onPrimary,
        AppButtonVariant.secondary => AppColors.primary,
        AppButtonVariant.outline => AppColors.primary,
        AppButtonVariant.text => AppColors.primary,
        AppButtonVariant.danger => AppColors.onError,
      };
}
