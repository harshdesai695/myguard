import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';
import 'package:myguard_frontend/core/utils/formatters.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});
  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  bool _loading = true;
  int _residents = 0;
  int _guards = 0;
  int _openTickets = 0;
  int _todayVisitors = 0;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    // TODO: GET /api/v1/dashboard/summary?societyId=xxx
    await Future<void>.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _loading
            ? const AppShimmerList(itemCount: 4, itemHeight: 100)
            : RefreshIndicator(
                onRefresh: _load,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(Formatters.greeting(), style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600)),
                    const SizedBox(height: AppSpacing.xxs),
                    Text('Admin Dashboard', style: AppTypography.headingLarge),
                    const SizedBox(height: AppSpacing.lg),
                    GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), mainAxisSpacing: AppSpacing.sm, crossAxisSpacing: AppSpacing.sm, childAspectRatio: 1.4, children: [
                      _DashboardCard(icon: Icons.people, label: 'Residents', value: '$_residents', color: AppColors.primary),
                      _DashboardCard(icon: Icons.security, label: 'Guards', value: '$_guards', color: AppColors.secondary),
                      _DashboardCard(icon: Icons.confirmation_number, label: 'Open Tickets', value: '$_openTickets', color: AppColors.warning),
                      _DashboardCard(icon: Icons.directions_walk, label: 'Today Visitors', value: '$_todayVisitors', color: AppColors.info),
                    ]),
                  ]),
                ),
              ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({required this.icon, required this.label, required this.value, required this.color});
  final IconData icon; final String label; final String value; final Color color;
  @override
  Widget build(BuildContext context) {
    return Card(child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, color: color, size: 28),
      const SizedBox(height: AppSpacing.sm),
      Text(value, style: AppTypography.headingMedium),
      Text(label, style: AppTypography.caption.copyWith(color: AppColors.grey600)),
    ])));
  }
}
