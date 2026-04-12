import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';

class QrScanScreen extends StatelessWidget {
  const QrScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code'), backgroundColor: Colors.black, foregroundColor: Colors.white),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 280, height: 280,
              decoration: BoxDecoration(border: Border.all(color: AppColors.primary, width: 3), borderRadius: BorderRadius.circular(AppSpacing.lg)),
              child: const Center(child: Icon(Icons.qr_code_scanner_rounded, size: 80, color: AppColors.primary)),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Point camera at the QR code', style: AppTypography.bodyMedium.copyWith(color: Colors.white70)),
            const SizedBox(height: AppSpacing.sm),
            Text('QR scanning requires mobile_scanner package', style: AppTypography.caption.copyWith(color: Colors.white38)),
          ],
        ),
      ),
    );
  }
}
