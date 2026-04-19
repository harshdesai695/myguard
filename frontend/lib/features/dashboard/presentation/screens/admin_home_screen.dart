import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_state.dart';
import 'package:myguard_frontend/features/dashboard/presentation/bloc/dashboard_cubit.dart';
import 'package:myguard_frontend/core/utils/formatters.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});
  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  void _loadDashboard() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated && authState.user.societyId != null) {
      context.read<DashboardCubit>().loadSummary(authState.user.societyId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) return const AppShimmerList(itemCount: 4, itemHeight: 100);
            if (state is DashboardError) return AppErrorWidget(message: state.message, onRetry: _loadDashboard);
            if (state is DashboardLoaded) {
              final s = state.summary;
              return RefreshIndicator(
                onRefresh: () async => _loadDashboard(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(Formatters.greeting(), style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600)),
                    const SizedBox(height: AppSpacing.xxs),
                    Text('Admin Dashboard', style: AppTypography.headingLarge),
                    const SizedBox(height: AppSpacing.lg),
                    GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), mainAxisSpacing: AppSpacing.sm, crossAxisSpacing: AppSpacing.sm, childAspectRatio: 1.4, children: [
                      _DashboardCard(icon: Icons.people, label: 'Residents', value: '${s.totalResidents}', color: AppColors.primary),
                      _DashboardCard(icon: Icons.security, label: 'Guards', value: '${s.totalGuards}', color: AppColors.secondary),
                      _DashboardCard(icon: Icons.confirmation_number, label: 'Open Tickets', value: '${s.totalComplaints}', color: AppColors.warning),
                      _DashboardCard(icon: Icons.directions_walk, label: 'Today Visitors', value: '${s.totalVisitors}', color: AppColors.info),
                    ]),
                  ]),
                ),
              );
            }
            return const AppShimmerList(itemCount: 4, itemHeight: 100);
          },
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
