import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/core/utils/formatters.dart';

class ResidentHomeScreen extends StatelessWidget {
  const ResidentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Formatters.greeting(), style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600)),
              const SizedBox(height: AppSpacing.xxs),
              Text('Welcome Home', style: AppTypography.headingLarge),
              const SizedBox(height: AppSpacing.lg),
              _QuickActionsGrid(),
              const SizedBox(height: AppSpacing.lg),
              Text('Recent Activity', style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              _PlaceholderCard(text: 'No recent visitors'),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(icon: Icons.person_add_rounded, label: 'Pre-Approve', route: '/resident/visitor/pre-approve'),
      _QuickAction(icon: Icons.sos_rounded, label: 'SOS', route: '/resident/emergency/panic'),
      _QuickAction(icon: Icons.people_rounded, label: 'Daily Helps', route: '/resident/daily-help'),
      _QuickAction(icon: Icons.sports_tennis_rounded, label: 'Amenities', route: '/resident/amenities'),
      _QuickAction(icon: Icons.support_agent_rounded, label: 'Helpdesk', route: '/resident/helpdesk'),
      _QuickAction(icon: Icons.campaign_rounded, label: 'Notices', route: '/resident/notices'),
    ];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      children: actions.map((a) => _QuickActionCard(action: a, onTap: () => context.push(a.route))).toList(),
    );
  }
}

class _QuickAction {
  const _QuickAction({required this.icon, required this.label, required this.route});
  final IconData icon; final String label; final String route;
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.action, required this.onTap});
  final _QuickAction action; final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(action.icon, size: 28, color: AppColors.primary),
              const SizedBox(height: AppSpacing.xs),
              Text(action.label, style: AppTypography.labelSmall, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: Center(child: Text(text, style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500)))),
  );
}
