import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/emergency/presentation/bloc/emergency_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class ChildAlertsScreen extends StatefulWidget {
  const ChildAlertsScreen({super.key});

  @override
  State<ChildAlertsScreen> createState() => _ChildAlertsScreenState();
}

class _ChildAlertsScreenState extends State<ChildAlertsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EmergencyCubit>().loadChildAlerts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Child Alerts')),
      body: BlocBuilder<EmergencyCubit, EmergencyState>(
        builder: (context, state) {
          if (state is EmergencyLoading) return const AppShimmerList();
          if (state is EmergencyError) return AppErrorWidget(message: state.message, onRetry: () => context.read<EmergencyCubit>().loadChildAlerts());
          if (state is ChildAlertsLoaded) {
            if (state.alerts.isEmpty) return const AppEmptyWidget(message: 'No child alerts', icon: Icons.child_care_outlined);
            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: state.alerts.length,
              itemBuilder: (context, index) {
                final alert = state.alerts[index];
                final isEntry = alert.type == 'ENTRY';
                final color = isEntry ? AppColors.success : AppColors.warning;
                return Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(AppSpacing.md),
                    leading: CircleAvatar(
                      backgroundColor: color.withValues(alpha: 0.1),
                      child: Icon(isEntry ? Icons.login_rounded : Icons.logout_rounded, color: color),
                    ),
                    title: Text(alert.childName, style: AppTypography.titleMedium),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(alert.timestamp != null ? _formatDateTime(alert.timestamp!) : 'N/A', style: AppTypography.bodySmall.copyWith(color: AppColors.grey600)),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text(alert.type ?? '', style: AppTypography.labelSmall.copyWith(color: color)),
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

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
