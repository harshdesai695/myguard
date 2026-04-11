import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Admin Dashboard', style: AppTypography.headingLarge),
              const SizedBox(height: AppSpacing.lg),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: AppSpacing.sm,
                crossAxisSpacing: AppSpacing.sm,
                childAspectRatio: 1.4,
                children: const [
                  _DashboardCard(icon: Icons.people, label: 'Residents', value: '—', color: AppColors.primary),
                  _DashboardCard(icon: Icons.security, label: 'Guards', value: '—', color: AppColors.secondary),
                  _DashboardCard(icon: Icons.confirmation_number, label: 'Open Tickets', value: '—', color: AppColors.warning),
                  _DashboardCard(icon: Icons.directions_walk, label: "Today's Visitors", value: '—', color: AppColors.info),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({required this.icon, required this.label, required this.value, required this.color});
  final IconData icon; final String label; final String value; final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTypography.headingMedium),
          Text(label, style: AppTypography.caption.copyWith(color: AppColors.grey600)),
        ]),
      ),
    );
  }
}
