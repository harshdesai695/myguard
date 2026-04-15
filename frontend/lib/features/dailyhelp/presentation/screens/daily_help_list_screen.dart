import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/dailyhelp/presentation/bloc/dailyhelp_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';
import 'package:go_router/go_router.dart';

class DailyHelpListScreen extends StatefulWidget {
  const DailyHelpListScreen({super.key});

  @override
  State<DailyHelpListScreen> createState() => _DailyHelpListScreenState();
}

class _DailyHelpListScreenState extends State<DailyHelpListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DailyHelpCubit>().loadDailyHelps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Helps')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/resident/daily-help/register'),
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add Help'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: BlocBuilder<DailyHelpCubit, DailyHelpState>(
        builder: (context, state) {
          if (state is DailyHelpLoading) return const AppShimmerList();
          if (state is DailyHelpError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<DailyHelpCubit>().loadDailyHelps(),
            );
          }
          if (state is DailyHelpsLoaded) {
            if (state.dailyHelps.isEmpty) {
              return const AppEmptyWidget(
                message: 'No daily helps registered',
                icon: Icons.people_outline_rounded,
              );
            }
            return RefreshIndicator(
              onRefresh: () async => context.read<DailyHelpCubit>().loadDailyHelps(),
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: state.dailyHelps.length,
                itemBuilder: (context, index) {
                  final help = state.dailyHelps[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(AppSpacing.md),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
                        child: Icon(_typeIcon(help.type), color: AppColors.secondary),
                      ),
                      title: Text(help.name, style: AppTypography.titleMedium),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppSpacing.xxs),
                          Text(help.type, style: AppTypography.caption.copyWith(color: AppColors.grey600)),
                          Text(help.phone, style: AppTypography.bodySmall),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.check_circle_outline_rounded, color: AppColors.success),
                        tooltip: 'Mark Attendance',
                        onPressed: () => context.read<DailyHelpCubit>().markAttendance(help.id),
                      ),
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

  IconData _typeIcon(String type) => switch (type.toLowerCase()) {
        'maid' => Icons.cleaning_services_rounded,
        'cook' => Icons.restaurant_rounded,
        'driver' => Icons.directions_car_rounded,
        'nanny' => Icons.child_care_rounded,
        _ => Icons.person_rounded,
      };
}
