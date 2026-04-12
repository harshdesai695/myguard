import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class VehicleLogScreen extends StatefulWidget {
  const VehicleLogScreen({super.key});

  @override
  State<VehicleLogScreen> createState() => _VehicleLogScreenState();
}

class _VehicleLogScreenState extends State<VehicleLogScreen> {
  final _plateController = TextEditingController();

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle Log')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            AppTextField(
              label: 'Vehicle Number',
              controller: _plateController,
              hint: 'Enter plate number to search',
              prefixIcon: const Icon(Icons.directions_car_outlined, size: 20),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Entry logged'))),
                    icon: const Icon(Icons.login_rounded),
                    label: const Text('Log Entry'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.success,
                      minimumSize: const Size(0, 48),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exit logged'))),
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Log Exit'),
                    style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.directions_car_outlined, size: 64, color: AppColors.grey300),
                    const SizedBox(height: AppSpacing.md),
                    Text('Enter a vehicle number to log entry/exit', style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600)),
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
