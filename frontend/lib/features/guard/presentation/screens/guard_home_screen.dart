import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class GuardHomeScreen extends StatefulWidget {
  const GuardHomeScreen({super.key});
  @override
  State<GuardHomeScreen> createState() => _GuardHomeScreenState();
}

class _GuardHomeScreenState extends State<GuardHomeScreen> {
  bool _loading = true;
  int _pendingEntries = 0;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    // TODO: GET /api/v1/visitors?status=PENDING + GET /api/v1/guards/shifts
    await Future<void>.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: AppShimmerList(itemCount: 5, itemHeight: 80));
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Guard Dashboard', style: AppTypography.headingLarge),
              const SizedBox(height: AppSpacing.lg),
              _StatCard(icon: Icons.people_outline, label: 'Pending Entries', value: '$_pendingEntries', color: AppColors.warning),
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
      ),
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
