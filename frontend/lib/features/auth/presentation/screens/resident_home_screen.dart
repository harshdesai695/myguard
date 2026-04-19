import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/core/utils/formatters.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_state.dart';

class ResidentHomeScreen extends StatelessWidget {
  const ResidentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final userName = state is AuthAuthenticated ? state.user.name : 'Resident';
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(Formatters.greeting(), style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600)),
                const SizedBox(height: AppSpacing.xxs),
                Text('Welcome, $userName', style: AppTypography.headingLarge),
                const SizedBox(height: AppSpacing.lg),
                _QuickActionsGrid(),
                const SizedBox(height: AppSpacing.lg),
                Text('Recent Activity', style: AppTypography.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                Card(child: Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: Center(child: Text('No recent visitors', style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500))))),
              ]),
            ),
          ),
        );
      },
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      _QA(Icons.person_add_rounded, 'Pre-Approve', '/resident/visitor/pre-approve'),
      _QA(Icons.sos_rounded, 'SOS', '/resident/emergency/panic'),
      _QA(Icons.people_rounded, 'Daily Helps', '/resident/daily-help'),
      _QA(Icons.sports_tennis_rounded, 'Amenities', '/resident/amenities'),
      _QA(Icons.support_agent_rounded, 'Helpdesk', '/resident/helpdesk'),
      _QA(Icons.campaign_rounded, 'Notices', '/resident/notices'),
    ];
    return GridView.count(crossAxisCount: 3, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), mainAxisSpacing: AppSpacing.sm, crossAxisSpacing: AppSpacing.sm, children: actions.map((a) => Material(color: AppColors.surface, borderRadius: BorderRadius.circular(AppSpacing.md), child: InkWell(onTap: () => context.push(a.route), borderRadius: BorderRadius.circular(AppSpacing.md), child: Padding(padding: const EdgeInsets.all(AppSpacing.sm), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(a.icon, size: 28, color: AppColors.primary), const SizedBox(height: AppSpacing.xs), Text(a.label, style: AppTypography.labelSmall, textAlign: TextAlign.center)]))))).toList());
  }
}

class _QA { const _QA(this.icon, this.label, this.route); final IconData icon; final String label; final String route; }
