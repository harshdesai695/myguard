import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class VisitorExitScreen extends StatefulWidget {
  const VisitorExitScreen({super.key});
  @override
  State<VisitorExitScreen> createState() => _VisitorExitScreenState();
}

class _VisitorExitScreenState extends State<VisitorExitScreen> {
  final _searchC = TextEditingController();
  @override
  void dispose() { _searchC.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mark Visitor Exit')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            AppTextField(label: 'Search Active Visitors', controller: _searchC, hint: 'Name or phone', prefixIcon: const Icon(Icons.search_rounded, size: 20)),
            const SizedBox(height: AppSpacing.lg),
            Expanded(child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.logout_rounded, size: 64, color: AppColors.grey300),
              const SizedBox(height: AppSpacing.md),
              Text('Search for an active visitor to mark exit', style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600)),
            ]))),
          ],
        ),
      ),
    );
  }
}
