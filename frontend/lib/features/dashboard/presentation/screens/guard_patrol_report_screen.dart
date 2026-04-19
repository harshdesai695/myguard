import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/guard/presentation/bloc/patrol_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class GuardPatrolReportScreen extends StatefulWidget {
  const GuardPatrolReportScreen({super.key});

  @override
  State<GuardPatrolReportScreen> createState() => _GuardPatrolReportScreenState();
}

class _GuardPatrolReportScreenState extends State<GuardPatrolReportScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PatrolCubit>().loadCheckpoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patrol Reports')),
      body: BlocBuilder<PatrolCubit, PatrolState>(
        builder: (context, state) {
          if (state is PatrolLoading) {
            return const AppShimmerList();
          }
          if (state is PatrolError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<PatrolCubit>().loadCheckpoints(),
            );
          }
          if (state is CheckpointsLoaded) {
            final checkpoints = state.checkpoints;
            if (checkpoints.isEmpty) {
              return RefreshIndicator(
                onRefresh: () => context.read<PatrolCubit>().loadCheckpoints(),
                child: ListView(
                  children: const [
                    SizedBox(height: 200),
                    AppEmptyWidget(
                      message: 'No patrol checkpoints found.',
                      icon: Icons.shield_outlined,
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () => context.read<PatrolCubit>().loadCheckpoints(),
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: checkpoints.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final cp = checkpoints[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.location_on_rounded, color: AppColors.primary),
                      title: Text(cp.name, style: AppTypography.bodyMedium),
                      subtitle: Text(cp.location, style: AppTypography.caption),
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
