import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_state.dart';
import 'package:myguard_frontend/features/dashboard/presentation/bloc/dashboard_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class MoveInOutScreen extends StatefulWidget {
  const MoveInOutScreen({super.key});

  @override
  State<MoveInOutScreen> createState() => _MoveInOutScreenState();
}

class _MoveInOutScreenState extends State<MoveInOutScreen> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    final societyId = (authState is AuthAuthenticated)
        ? authState.user.societyId ?? ''
        : '';
    context.read<DashboardCubit>().loadSummary(societyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Move In/Out')),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const AppShimmerList(itemCount: 3, itemHeight: 100);
          }
          if (state is DashboardError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () {
                final authState = context.read<AuthBloc>().state;
                final societyId = (authState is AuthAuthenticated)
                    ? authState.user.societyId ?? ''
                    : '';
                context.read<DashboardCubit>().loadSummary(societyId);
              },
            );
          }
          if (state is DashboardLoaded) {
            final summary = state.summary;
            return RefreshIndicator(
              onRefresh: () {
                final authState = context.read<AuthBloc>().state;
                final societyId = (authState is AuthAuthenticated)
                    ? authState.user.societyId ?? ''
                    : '';
                return context.read<DashboardCubit>().loadSummary(societyId);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: AppSpacing.sm,
                      crossAxisSpacing: AppSpacing.sm,
                      childAspectRatio: 1.5,
                      children: [
                        _SummaryCard(
                          label: 'Total Residents',
                          value: '${summary.totalResidents}',
                          icon: Icons.people_rounded,
                          color: AppColors.primary,
                        ),
                        _SummaryCard(
                          label: 'Total Vehicles',
                          value: '${summary.totalVehicles}',
                          icon: Icons.directions_car_rounded,
                          color: AppColors.info,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Text(
                          'Move-in/out records are tracked via the dashboard summary. A dedicated move-in/out endpoint is available on the backend for detailed tracking.',
                          style: AppTypography.bodySmall
                              .copyWith(color: AppColors.grey600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: AppSpacing.xs),
            Text(value,
                style: AppTypography.headingMedium.copyWith(color: color)),
            Text(label,
                style:
                    AppTypography.caption.copyWith(color: AppColors.grey600)),
          ],
        ),
      ),
    );
  }
}
