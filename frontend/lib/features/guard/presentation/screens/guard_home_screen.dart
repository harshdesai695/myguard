import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_state.dart';

class GuardHomeScreen extends StatelessWidget {
  const GuardHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final userName = state is AuthAuthenticated ? state.user.name : 'Guard';
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Welcome, $userName', style: AppTypography.headingLarge),
                const SizedBox(height: AppSpacing.lg),
                _StatCard(icon: Icons.people_outline, label: 'Pending Entries', value: '0', color: AppColors.warning),
                const SizedBox(height: AppSpacing.sm),
                _StatCard(icon: Icons.shield_outlined, label: 'Patrol Status', value: 'Not Started', color: AppColors.info),
                const SizedBox(height: AppSpacing.sm),
                _StatCard(icon: Icons.access_time, label: 'Shift', value: 'Active', color: AppColors.success),
                const SizedBox(height: AppSpacing.lg),
                Text('Quick Actions', style: AppTypography.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                GridView.count(crossAxisCount: 3, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), mainAxisSpacing: AppSpacing.sm, crossAxisSpacing: AppSpacing.sm, children: [
                  _QuickAction(icon: Icons.badge_outlined, label: 'Daily Help\nCheck-In', onTap: () => context.push('/guard/daily-help/check-in')),
                  _QuickAction(icon: Icons.phone_in_talk_outlined, label: 'E-Intercom', onTap: () => context.push('/guard/e-intercom')),
                  _QuickAction(icon: Icons.directions_car_outlined, label: 'Vehicle Log', onTap: () => context.push('/guard/vehicle-log')),
                  _QuickAction(icon: Icons.fact_check_outlined, label: 'Material\nVerify', onTap: () => context.push('/guard/material-verify')),
                  _QuickAction(icon: Icons.logout_rounded, label: 'Visitor\nExit', onTap: () => context.push('/guard/visitor/exit')),
                  _QuickAction(icon: Icons.group_add_rounded, label: 'Group\nEntry', onTap: () => context.push('/guard/visitor/group-entry')),
                ]),
              ]),
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.label, required this.value, required this.color});
  final IconData icon; final String label; final String value; final Color color;
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: Row(children: [
    Container(padding: const EdgeInsets.all(AppSpacing.sm), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppSpacing.sm)), child: Icon(icon, color: color, size: 24)),
    const SizedBox(width: AppSpacing.md),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.grey600)), Text(value, style: AppTypography.titleMedium)]),
  ])));
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, required this.onTap});
  final IconData icon; final String label; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(color: AppColors.surface, borderRadius: BorderRadius.circular(AppSpacing.md), child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(AppSpacing.md), child: Padding(padding: const EdgeInsets.all(AppSpacing.sm), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 28, color: AppColors.primary), const SizedBox(height: AppSpacing.xs), Text(label, style: AppTypography.labelSmall, textAlign: TextAlign.center)]))));
}
