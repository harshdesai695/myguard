import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_radius.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          secondary: AppColors.secondary,
          onSecondary: AppColors.onSecondary,
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          error: AppColors.error,
          onError: AppColors.onError,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.onBackground,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: AppTypography.headingMedium,
        ),
        cardTheme: CardThemeData(
          color: AppColors.background,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
            side: const BorderSide(color: AppColors.divider),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            textStyle: AppTypography.buttonMedium,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderRadiusMd,
            ),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTypography.buttonMedium,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderRadiusMd,
            ),
            side: const BorderSide(color: AppColors.primary),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTypography.buttonMedium,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.grey50,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusMd,
            borderSide: const BorderSide(color: AppColors.grey300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusMd,
            borderSide: const BorderSide(color: AppColors.grey300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusMd,
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusMd,
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusMd,
            borderSide: const BorderSide(color: AppColors.error, width: 2),
          ),
          hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
          errorStyle: AppTypography.caption.copyWith(color: AppColors.error),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
          space: 1,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.background,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.grey500,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusFull,
          ),
        ),
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusLg,
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.lg),
            ),
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryLight,
          onPrimary: AppColors.grey900,
          secondary: AppColors.secondaryLight,
          onSecondary: AppColors.grey900,
          surface: AppColors.darkSurface,
          onSurface: AppColors.darkOnSurface,
          error: AppColors.error,
          onError: AppColors.onError,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkBackground,
          foregroundColor: AppColors.darkOnBackground,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: AppTypography.headingMedium,
        ),
        cardTheme: CardThemeData(
          color: AppColors.darkSurface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
            side: const BorderSide(color: AppColors.darkDivider),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryLight,
            foregroundColor: AppColors.grey900,
            textStyle: AppTypography.buttonMedium,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderRadiusMd,
            ),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryLight,
            textStyle: AppTypography.buttonMedium,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderRadiusMd,
            ),
            side: const BorderSide(color: AppColors.primaryLight),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkSurfaceVariant,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusMd,
            borderSide: const BorderSide(color: AppColors.darkDivider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusMd,
            borderSide: const BorderSide(color: AppColors.darkDivider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusMd,
            borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusMd,
            borderSide: const BorderSide(color: AppColors.error),
          ),
          hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.grey600),
          errorStyle: AppTypography.caption.copyWith(color: AppColors.error),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.darkDivider,
          thickness: 1,
          space: 1,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkSurface,
          selectedItemColor: AppColors.primaryLight,
          unselectedItemColor: AppColors.grey600,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusFull,
          ),
        ),
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusLg,
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.lg),
            ),
          ),
        ),
      );
}
