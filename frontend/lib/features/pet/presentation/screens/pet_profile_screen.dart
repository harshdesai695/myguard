import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';

class PetProfileScreen extends StatelessWidget {
  const PetProfileScreen({required this.petId, super.key});
  final String petId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pet Profile')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(AppSpacing.md), child: Column(children: [
        Card(child: Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: Column(children: [
          CircleAvatar(radius: 48, backgroundColor: AppColors.secondary.withValues(alpha: 0.1), child: const Icon(Icons.pets_rounded, size: 48, color: AppColors.secondary)),
          const SizedBox(height: AppSpacing.md),
          Text('Pet Name', style: AppTypography.headingMedium),
          Text('ID: $petId', style: AppTypography.caption.copyWith(color: AppColors.grey500)),
        ]))),
        const SizedBox(height: AppSpacing.md),
        Card(child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Details', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          _Row(label: 'Type', value: '—'), _Row(label: 'Breed', value: '—'), _Row(label: 'Age', value: '—'), _Row(label: 'Owner', value: '—'),
        ]))),
        const SizedBox(height: AppSpacing.md),
        Card(child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Text('Vaccinations', style: AppTypography.titleMedium), const Spacer(), TextButton.icon(onPressed: () {}, icon: const Icon(Icons.add, size: 16), label: const Text('Add'))]),
          const SizedBox(height: AppSpacing.sm),
          Center(child: Text('No vaccination records', style: AppTypography.bodySmall.copyWith(color: AppColors.grey500))),
        ]))),
      ])),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});
  final String label; final String value;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600)), Text(value, style: AppTypography.bodyMedium)]));
}
