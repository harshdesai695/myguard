import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _ReportTile(icon: Icons.directions_walk_rounded, title: 'Visitor Reports', subtitle: 'Daily/weekly/monthly visitor stats', color: AppColors.primary, onTap: () => context.push('/admin/visitors')),
          _ReportTile(icon: Icons.shield_rounded, title: 'Guard Patrol Reports', subtitle: 'Patrol completion, missed checkpoints', color: AppColors.secondary, onTap: () => context.push('/admin/guards/patrol-report')),
          _ReportTile(icon: Icons.confirmation_number_rounded, title: 'Helpdesk Reports', subtitle: 'Tickets by category, SLA compliance', color: AppColors.warning, onTap: () => context.push('/admin/helpdesk/reports')),
          _ReportTile(icon: Icons.sports_tennis_rounded, title: 'Amenity Reports', subtitle: 'Booking stats, utilization rates', color: AppColors.info, onTap: () => context.push('/admin/amenities/bookings')),
          _ReportTile(icon: Icons.swap_vert_rounded, title: 'Move-in/out Reports', subtitle: 'Occupancy rates, move history', color: Colors.purple, onTap: () => context.push('/admin/move-in-out')),
        ],
      ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  const _ReportTile({required this.icon, required this.title, required this.subtitle, required this.color, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppSpacing.sm)),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: AppTypography.titleMedium),
        subtitle: Text(subtitle, style: AppTypography.caption.copyWith(color: AppColors.grey600)),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.grey400),
        onTap: onTap,
      ),
    );
  }
}
