import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';

class AmenityDetailScreen extends StatelessWidget {
  const AmenityDetailScreen({required this.amenityId, super.key});
  final String amenityId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Amenity Details')),
      bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: FilledButton(onPressed: () => context.push('/resident/amenities/book/$amenityId'), style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 48)), child: const Text('Book Now')))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(height: 200, width: double.infinity, decoration: BoxDecoration(color: AppColors.primaryLight.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppSpacing.md)), child: const Icon(Icons.sports_rounded, size: 64, color: AppColors.primary)),
          const SizedBox(height: AppSpacing.md),
          Text('Amenity Name', style: AppTypography.headingMedium),
          const SizedBox(height: AppSpacing.xs),
          Text('ID: $amenityId', style: AppTypography.caption.copyWith(color: AppColors.grey500)),
          const SizedBox(height: AppSpacing.lg),
          _DetailRow(icon: Icons.people_outlined, label: 'Capacity', value: '—'),
          _DetailRow(icon: Icons.access_time_outlined, label: 'Operating Hours', value: '—'),
          _DetailRow(icon: Icons.currency_rupee_outlined, label: 'Pricing', value: '—'),
          _DetailRow(icon: Icons.timelapse_outlined, label: 'Cool Down', value: '—'),
          const SizedBox(height: AppSpacing.lg),
          Text('Rules', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text('• Follow community guidelines\n• Book at least 2 hours in advance\n• Cancel before 1 hour of booking', style: AppTypography.bodySmall.copyWith(color: AppColors.grey600)),
        ]),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.label, required this.value});
  final IconData icon; final String label; final String value;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm), child: Row(children: [Icon(icon, size: 20, color: AppColors.grey500), const SizedBox(width: AppSpacing.md), Text(label, style: AppTypography.bodyMedium), const Spacer(), Text(value, style: AppTypography.titleSmall)]));
}
