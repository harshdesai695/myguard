import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/guard/presentation/bloc/patrol_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';
import 'package:myguard_frontend/shared/widgets/app_snackbar.dart';

class GuardShiftScreen extends StatefulWidget {
  const GuardShiftScreen({super.key});

  @override
  State<GuardShiftScreen> createState() => _GuardShiftScreenState();
}

class _GuardShiftScreenState extends State<GuardShiftScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PatrolCubit>().loadShifts();
  }

  void _showCreateShiftSheet() {
    final guardUidController = TextEditingController();
    final startTimeController = TextEditingController();
    final endTimeController = TextEditingController();
    final positionController = TextEditingController();
    final shiftNameController = TextEditingController();
    final dateController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.md,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Create Shift', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: guardUidController,
              decoration: const InputDecoration(labelText: 'Guard UID'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: shiftNameController,
              decoration: const InputDecoration(labelText: 'Shift Name'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: startTimeController,
              decoration: const InputDecoration(labelText: 'Start Time (HH:mm)'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: endTimeController,
              decoration: const InputDecoration(labelText: 'End Time (HH:mm)'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: positionController,
              decoration: const InputDecoration(labelText: 'Gate / Position'),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () {
                context.read<PatrolCubit>().createShift({
                  'guardUid': guardUidController.text.trim(),
                  'shiftName': shiftNameController.text.trim(),
                  'date': dateController.text.trim(),
                  'startTime': startTimeController.text.trim(),
                  'endTime': endTimeController.text.trim(),
                  'position': positionController.text.trim(),
                });
                Navigator.of(ctx).pop();
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guard Shifts')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateShiftSheet,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create Shift'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: BlocConsumer<PatrolCubit, PatrolState>(
        listener: (context, state) {
          if (state is PatrolLoggedSuccess) {
            AppSnackbar.success(context, message: state.message);
            context.read<PatrolCubit>().loadShifts();
          }
          if (state is PatrolError) {
            AppSnackbar.error(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is PatrolLoading) {
            return const AppShimmerList();
          }
          if (state is PatrolError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<PatrolCubit>().loadShifts(),
            );
          }
          if (state is ShiftsLoaded) {
            final shifts = state.shifts;
            if (shifts.isEmpty) {
              return RefreshIndicator(
                onRefresh: () => context.read<PatrolCubit>().loadShifts(),
                child: ListView(
                  children: const [
                    SizedBox(height: 200),
                    AppEmptyWidget(
                      message: 'No shifts scheduled.',
                      icon: Icons.schedule_outlined,
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () => context.read<PatrolCubit>().loadShifts(),
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: shifts.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final shift = shifts[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.schedule_rounded, color: AppColors.primary),
                      title: Text(shift.shiftName, style: AppTypography.bodyMedium),
                      subtitle: Text(
                        '${shift.date} • ${shift.startTime} - ${shift.endTime}',
                        style: AppTypography.caption,
                      ),
                      trailing: shift.status != null
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
                              decoration: BoxDecoration(
                                color: AppColors.info.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                shift.status!,
                                style: AppTypography.caption.copyWith(color: AppColors.info),
                              ),
                            )
                          : null,
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
