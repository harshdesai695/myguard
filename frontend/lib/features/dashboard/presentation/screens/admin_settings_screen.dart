import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_event.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _SettingsSection(
            title: 'General',
            children: [
              _SettingsTile(icon: Icons.notifications_outlined, title: 'Notifications', subtitle: 'Push notification preferences', onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notification preferences - coming soon')))),
              _SettingsTile(icon: Icons.dark_mode_outlined, title: 'Appearance', subtitle: 'Theme, dark mode', onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appearance settings - coming soon')))),
              _SettingsTile(icon: Icons.language_outlined, title: 'Language', subtitle: 'English', onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Language settings - coming soon')))),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _SettingsSection(
            title: 'Society',
            children: [
              _SettingsTile(icon: Icons.edit_outlined, title: 'Edit Society Info', subtitle: 'Name, address, logo', onTap: () => context.push('/admin/society')),
              _SettingsTile(icon: Icons.access_time_outlined, title: 'Gate Timing', subtitle: 'Set visitor allowed hours', onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gate timing settings - coming soon')))),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _SettingsSection(
            title: 'Account',
            children: [
              _SettingsTile(icon: Icons.privacy_tip_outlined, title: 'Privacy Policy', onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Privacy policy')))),
              _SettingsTile(icon: Icons.description_outlined, title: 'Terms of Service', onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Terms of service')))),
              _SettingsTile(icon: Icons.info_outlined, title: 'About', subtitle: 'Version 1.0.0', onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('MyGuard v1.0.0')))),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: () => context.read<AuthBloc>().add(const AuthLogoutRequested()),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Sign Out'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.labelMedium.copyWith(color: AppColors.grey500)),
        const SizedBox(height: AppSpacing.sm),
        Card(child: Column(children: children)),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.icon, required this.title, this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.grey700, size: 22),
      title: Text(title, style: AppTypography.bodyMedium),
      subtitle: subtitle != null ? Text(subtitle!, style: AppTypography.caption.copyWith(color: AppColors.grey500)) : null,
      trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.grey400),
      onTap: onTap,
    );
  }
}
