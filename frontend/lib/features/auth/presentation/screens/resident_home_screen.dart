import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/core/utils/formatters.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class ResidentHomeScreen extends StatefulWidget {
  const ResidentHomeScreen({super.key});
  @override
  State<ResidentHomeScreen> createState() => _ResidentHomeScreenState();
}

class _ResidentHomeScreenState extends State<ResidentHomeScreen> {
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    // TODO: GET /api/v1/auth/profile + recent visitors
    await Future<void>.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: AppShimmerList(itemCount: 6, itemHeight: 80));
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(Formatters.greeting(), style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600)),
              const SizedBox(height: AppSpacing.xxs),
              Text('Welcome Home', style: AppTypography.headingLarge),
              const SizedBox(height: AppSpacing.lg),
              _QuickActionsGrid(),
              const SizedBox(height: AppSpacing.lg),
              Text('Recent Activity', style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              Card(child: Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: Center(child: Text('No recent visitors', style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500))))),
            ]),
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
