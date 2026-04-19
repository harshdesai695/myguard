import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/helpdesk/presentation/bloc/helpdesk_bloc.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class HelpdeskManagementScreen extends StatefulWidget {
  const HelpdeskManagementScreen({super.key});

  @override
  State<HelpdeskManagementScreen> createState() => _HelpdeskManagementScreenState();
}

class _HelpdeskManagementScreenState extends State<HelpdeskManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HelpdeskBloc>().add(const TicketsFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Helpdesk Management')),
      body: BlocBuilder<HelpdeskBloc, HelpdeskState>(
        builder: (context, state) {
          if (state is HelpdeskLoading) return const AppShimmerList();
          if (state is HelpdeskError) {
            return AppErrorWidget(message: state.message, onRetry: () => context.read<HelpdeskBloc>().add(const TicketsFetched()));
          }
          if (state is TicketsLoaded) {
            if (state.tickets.isEmpty) {
              return const AppEmptyWidget(message: 'No tickets yet', icon: Icons.confirmation_number_outlined);
            }
            return RefreshIndicator(
              onRefresh: () async => context.read<HelpdeskBloc>().add(const TicketsFetched()),
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: state.tickets.length,
                itemBuilder: (context, index) {
                  final ticket = state.tickets[index];
                  final priorityColor = switch (ticket.priority) {
                    'CRITICAL' => AppColors.error,
                    'HIGH' => Colors.orange,
                    'MEDIUM' => AppColors.warning,
                    _ => AppColors.grey500,
                  };
                  final statusColor = switch (ticket.status) {
                    'OPEN' => AppColors.info,
                    'IN_PROGRESS' => AppColors.warning,
                    'RESOLVED' => AppColors.success,
                    'CLOSED' => AppColors.grey500,
                    'ESCALATED' => AppColors.error,
                    _ => AppColors.grey500,
                  };
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Expanded(child: Text(ticket.title, style: AppTypography.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: priorityColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                              child: Text(ticket.priority ?? 'LOW', style: AppTypography.labelSmall.copyWith(color: priorityColor)),
                            ),
                          ]),
                          const SizedBox(height: AppSpacing.xs),
                          Text(ticket.description, style: AppTypography.bodySmall.copyWith(color: AppColors.grey600), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: AppSpacing.sm),
                          Row(children: [
                            Icon(Icons.category_outlined, size: 14, color: AppColors.grey500),
                            const SizedBox(width: 4),
                            Text(ticket.category, style: AppTypography.caption.copyWith(color: AppColors.grey600)),
                            if (ticket.assignedTo != null) ...[
                              const SizedBox(width: AppSpacing.sm),
                              Icon(Icons.person_outline, size: 14, color: AppColors.grey500),
                              const SizedBox(width: 4),
                              Text('Assigned', style: AppTypography.caption.copyWith(color: AppColors.grey600)),
                            ],
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                              child: Text(ticket.status.replaceAll('_', ' '), style: AppTypography.labelSmall.copyWith(color: statusColor)),
                            ),
                          ]),
                        ],
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
}
