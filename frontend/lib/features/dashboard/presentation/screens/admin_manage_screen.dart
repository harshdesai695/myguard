import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';

class AdminManageScreen extends StatelessWidget {
  const AdminManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _SectionHeader(title: 'Society'),
          _ManageTile(icon: Icons.apartment_rounded, title: 'Society Settings', subtitle: 'Edit society details, towers, blocks', onTap: () => context.push('/admin/society')),
          _ManageTile(icon: Icons.door_front_door_rounded, title: 'Flat Management', subtitle: 'Add/edit flats, assign residents', onTap: () => context.push('/admin/flats')),
          _ManageTile(icon: Icons.people_rounded, title: 'User Management', subtitle: 'Manage residents, guards, roles', onTap: () => context.push('/admin/users')),
          const SizedBox(height: AppSpacing.md),
          _SectionHeader(title: 'Security'),
          _ManageTile(icon: Icons.security_rounded, title: 'Guard Management', subtitle: 'Guards, shifts, assignments', onTap: () => context.push('/admin/guards')),
          _ManageTile(icon: Icons.receipt_long_rounded, title: 'Material Gatepasses', subtitle: 'Approve/reject gatepasses', onTap: () => context.push('/admin/material-gatepasses')),
          _ManageTile(icon: Icons.phone_callback_rounded, title: 'Emergency Contacts', subtitle: 'Manage emergency numbers', onTap: () => context.push('/admin/emergency-contacts')),
          const SizedBox(height: AppSpacing.md),
          _SectionHeader(title: 'Community'),
          _ManageTile(icon: Icons.campaign_rounded, title: 'Notice Management', subtitle: 'Create, edit notices', onTap: () => context.push('/admin/notices')),
          _ManageTile(icon: Icons.poll_rounded, title: 'Poll Management', subtitle: 'Create, manage polls', onTap: () => context.push('/admin/polls')),
          _ManageTile(icon: Icons.sports_tennis_rounded, title: 'Amenity Management', subtitle: 'Configure amenities, slots, pricing', onTap: () => context.push('/admin/amenities')),
          _ManageTile(icon: Icons.confirmation_number_rounded, title: 'Helpdesk Management', subtitle: 'All tickets, assign staff', onTap: () => context.push('/admin/helpdesk')),
          const SizedBox(height: AppSpacing.md),
          _SectionHeader(title: 'Other'),
          _ManageTile(icon: Icons.directions_car_rounded, title: 'Vehicle & Parking', subtitle: 'Allocate parking, manage vehicles', onTap: () => context.push('/admin/vehicles')),
          _ManageTile(icon: Icons.description_rounded, title: 'Document Management', subtitle: 'Upload society documents', onTap: () => context.push('/admin/documents')),
          _ManageTile(icon: Icons.swap_vert_rounded, title: 'Move In/Out', subtitle: 'Move-in/out workflows', onTap: () => context.push('/admin/move-in-out')),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm, top: AppSpacing.xs),
        child: Text(title, style: AppTypography.labelMedium.copyWith(color: AppColors.grey500)),
      );
}

class _ManageTile extends StatelessWidget {
  const _ManageTile({required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryLight.withValues(alpha: 0.1),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(title, style: AppTypography.titleSmall),
        subtitle: Text(subtitle, style: AppTypography.caption.copyWith(color: AppColors.grey600)),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.grey400),
        onTap: onTap,
      ),
    );
  }
}
