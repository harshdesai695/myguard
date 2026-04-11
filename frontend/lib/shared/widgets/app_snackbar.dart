import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_radius.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';

class AppSnackbar {
  const AppSnackbar._();

  static void show(
    BuildContext context, {
    required String message,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: AppTypography.bodyMedium),
          action: action,
          duration: duration,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
      );
  }

  static void success(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.onSuccess, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.onSuccess),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
      );
  }

  static void error(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: AppColors.onError, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.onError),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
      );
  }

  static void warning(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.onWarning, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.onWarning),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
      );
  }
}
