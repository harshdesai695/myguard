import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/guard/presentation/bloc/patrol_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class PatrolScreen extends StatefulWidget {
  const PatrolScreen({super.key});

  @override
  State<PatrolScreen> createState() => _PatrolScreenState();
}

class _PatrolScreenState extends State<PatrolScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PatrolCubit>().loadCheckpoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patrol')),
      body: BlocConsumer<PatrolCubit, PatrolState>(
        listener: (context, state) {
          if (state is PatrolLoggedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            context.read<PatrolCubit>().loadCheckpoints();
          }
        },
        builder: (context, state) {
          if (state is PatrolLoading) return const AppLoader();
          if (state is PatrolError) return AppErrorWidget(message: state.message, onRetry: () => context.read<PatrolCubit>().loadCheckpoints());
          if (state is CheckpointsLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: state.checkpoints.length,
              itemBuilder: (context, index) {
                final cp = state.checkpoints[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(AppSpacing.md),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryLight.withValues(alpha: 0.1),
                      child: const Icon(Icons.location_on_rounded, color: AppColors.primary),
                    ),
                    title: Text(cp.name, style: AppTypography.titleMedium),
                    subtitle: Text(cp.location, style: AppTypography.bodySmall.copyWith(color: AppColors.grey600)),
                    trailing: FilledButton.icon(
                      onPressed: () => context.read<PatrolCubit>().logPatrol(checkpointId: cp.id, societyId: cp.societyId ?? ''),
                      icon: const Icon(Icons.qr_code_scanner_rounded, size: 16),
                      label: const Text('Scan'),
                      style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
