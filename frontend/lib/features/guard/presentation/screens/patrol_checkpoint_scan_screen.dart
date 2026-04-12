import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';

class PatrolCheckpointScanScreen extends StatelessWidget {
  const PatrolCheckpointScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Checkpoint'), backgroundColor: Colors.black, foregroundColor: Colors.white),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 280, height: 280,
            decoration: BoxDecoration(border: Border.all(color: AppColors.secondary, width: 3), borderRadius: BorderRadius.circular(AppSpacing.lg)),
            child: const Center(child: Icon(Icons.qr_code_scanner_rounded, size: 80, color: AppColors.secondary)),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Scan patrol checkpoint QR code', style: AppTypography.bodyMedium.copyWith(color: Colors.white70)),
        ]),
      ),
    );
  }
}
