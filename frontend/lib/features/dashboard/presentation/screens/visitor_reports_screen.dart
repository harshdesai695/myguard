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

class VisitorReportsScreen extends StatefulWidget {
  const VisitorReportsScreen({super.key});

  @override
  State<VisitorReportsScreen> createState() => _VisitorReportsScreenState();
}

class _VisitorReportsScreenState extends State<VisitorReportsScreen> {
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
      appBar: AppBar(title: const Text('Visitor Reports')),
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
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Row(
                          children: [
                            const Icon(Icons.directions_walk_rounded,
                                size: 48, color: AppColors.primary),
                            const SizedBox(width: AppSpacing.md),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Visitors',
                                    style: AppTypography.caption),
                                Text('${summary.totalVisitors}',
                                    style: AppTypography.headingMedium
                                        .copyWith(color: AppColors.primary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Text(
                          'Detailed visitor statistics are aggregated from the dashboard summary. Check the main dashboard for real-time data.',
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
