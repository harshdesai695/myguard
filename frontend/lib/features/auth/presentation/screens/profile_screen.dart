import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_event.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = state.user;
        final roleName = switch (user.role) {
          'ROLE_ADMIN' => 'Admin',
          'ROLE_GUARD' => 'Security Guard',
          _ => 'Resident',
        };

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary,
                  backgroundImage: user.profilePhotoUrl != null && user.profilePhotoUrl!.isNotEmpty
                      ? NetworkImage(user.profilePhotoUrl!)
                      : null,
                  child: user.profilePhotoUrl == null || user.profilePhotoUrl!.isEmpty
                      ? Text(
                          user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                          style: const TextStyle(fontSize: 40, color: Colors.white),
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                // Name
                Text(user.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                // Role chip
                Chip(
                  label: Text(roleName, style: const TextStyle(color: Colors.white, fontSize: 12)),
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(height: 24),

                // Info card
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _InfoRow(icon: Icons.email_outlined, label: 'Email', value: user.email),
                        const Divider(height: 24),
                        _InfoRow(icon: Icons.phone_outlined, label: 'Phone', value: user.phone),
                        if (user.flatNumber != null && user.flatNumber!.isNotEmpty) ...[
                          const Divider(height: 24),
                          _InfoRow(icon: Icons.apartment_outlined, label: 'Flat', value: user.flatNumber!),
                        ],
                        if (user.societyId != null && user.societyId!.isNotEmpty) ...[
                          const Divider(height: 24),
                          _InfoRow(icon: Icons.location_city_outlined, label: 'Society ID', value: user.societyId!),
                        ],
                        const Divider(height: 24),
                        _InfoRow(
                          icon: Icons.circle,
                          label: 'Status',
                          value: user.status,
                          valueColor: user.isActive ? AppColors.secondary : AppColors.error,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Menu items
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      _MenuTile(icon: Icons.edit_outlined, title: 'Edit Profile', onTap: () {}),
                      const Divider(height: 1),
                      _MenuTile(icon: Icons.lock_outline, title: 'Change Password', onTap: () {}),
                      const Divider(height: 1),
                      _MenuTile(icon: Icons.notifications_outlined, title: 'Notifications', onTap: () {}),
                      const Divider(height: 1),
                      _MenuTile(icon: Icons.help_outline, title: 'Help & Support', onTap: () {}),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Logout button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                context.read<AuthBloc>().add(const AuthLogoutRequested());
                                context.go('/auth/login');
                              },
                              child: const Text('Logout', style: TextStyle(color: AppColors.error)),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout, color: AppColors.error),
                    label: const Text('Logout', style: TextStyle(color: AppColors.error)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value, this.valueColor});
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: valueColor)),
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.title, required this.onTap});
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.onSurfaceVariant),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
      onTap: onTap,
    );
  }
}
