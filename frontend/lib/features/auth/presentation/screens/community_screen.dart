import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _CommunityCard(
            icon: Icons.campaign_outlined,
            title: 'Notices',
            subtitle: 'Community announcements & updates',
            color: AppColors.primary,
            onTap: () => context.push('/resident/notices'),
          ),
          const SizedBox(height: 12),
          _CommunityCard(
            icon: Icons.poll_outlined,
            title: 'Polls & Surveys',
            subtitle: 'Vote on community decisions',
            color: AppColors.secondary,
            onTap: () => context.push('/resident/polls'),
          ),
          const SizedBox(height: 12),
          _CommunityCard(
            icon: Icons.store_outlined,
            title: 'Marketplace',
            subtitle: 'Buy & sell within your community',
            color: Colors.orange,
            onTap: () => context.push('/resident/marketplace'),
          ),
          const SizedBox(height: 12),
          _CommunityCard(
            icon: Icons.phone_in_talk_outlined,
            title: 'Emergency Contacts',
            subtitle: 'Quick access to emergency numbers',
            color: AppColors.error,
            onTap: () => context.push('/resident/emergency'),
          ),
          const SizedBox(height: 12),
          _CommunityCard(
            icon: Icons.description_outlined,
            title: 'Documents',
            subtitle: 'Society bylaws, minutes & reports',
            color: Colors.teal,
            onTap: () => context.push('/resident/documents'),
          ),
        ],
      ),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  const _CommunityCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
        onTap: onTap,
      ),
    );
  }
}
