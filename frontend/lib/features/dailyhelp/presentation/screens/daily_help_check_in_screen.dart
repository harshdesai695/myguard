import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class DailyHelpCheckInScreen extends StatefulWidget {
  const DailyHelpCheckInScreen({super.key});

  @override
  State<DailyHelpCheckInScreen> createState() => _DailyHelpCheckInScreenState();
}

class _DailyHelpCheckInScreenState extends State<DailyHelpCheckInScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Help Check-In')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            AppTextField(
              label: 'Search',
              controller: _searchController,
              hint: 'Search by name or phone',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.badge_outlined, size: 64, color: AppColors.grey300),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Search for a daily help to mark attendance',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
