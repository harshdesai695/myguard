import 'package:flutter/material.dart' hide MaterialState;
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class MaterialVerifyScreen extends StatefulWidget {
  const MaterialVerifyScreen({super.key});

  @override
  State<MaterialVerifyScreen> createState() => _MaterialVerifyScreenState();
}

class _MaterialVerifyScreenState extends State<MaterialVerifyScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Material Gatepass')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            AppTextField(
              label: 'Search Gatepass',
              controller: _searchController,
              hint: 'Enter gatepass ID or description',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.fact_check_outlined, size: 64, color: AppColors.grey300),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Search for a gatepass to verify at the gate',
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
