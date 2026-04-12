import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/visitor/presentation/bloc/visitor_bloc.dart';
import 'package:myguard_frontend/features/visitor/presentation/bloc/visitor_bloc_models.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class VisitorDetailScreen extends StatefulWidget {
  const VisitorDetailScreen({required this.visitorId, super.key});
  final String visitorId;

  @override
  State<VisitorDetailScreen> createState() => _VisitorDetailScreenState();
}

class _VisitorDetailScreenState extends State<VisitorDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visitor Details')),
      body: BlocConsumer<VisitorBloc, VisitorState>(
        listener: (context, state) {
          if (state is VisitorActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is VisitorLoading) return const AppLoader();
          if (state is VisitorError) {
            return AppErrorWidget(message: state.message, onRetry: () {});
          }
          if (state is VisitorsLoaded) {
            final visitor = state.visitors.where((v) => v.id == widget.visitorId).firstOrNull;
            if (visitor == null) {
              return const AppErrorWidget(message: 'Visitor not found');
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  _HeaderCard(visitor: visitor),
                  const SizedBox(height: AppSpacing.md),
                  _InfoCard(
                    children: [
                      _InfoRow(label: 'Phone', value: visitor.visitorPhone, icon: Icons.phone_outlined),
                      _InfoRow(label: 'Purpose', value: visitor.purpose, icon: Icons.description_outlined),
                      _InfoRow(label: 'Flat', value: visitor.flatId, icon: Icons.apartment_outlined),
                      if (visitor.vehicleNumber != null)
                        _InfoRow(label: 'Vehicle', value: visitor.vehicleNumber!, icon: Icons.directions_car_outlined),
                      if (visitor.entryTime != null)
                        _InfoRow(label: 'Entry', value: _formatTime(visitor.entryTime!), icon: Icons.login_outlined),
                      if (visitor.exitTime != null)
                        _InfoRow(label: 'Exit', value: _formatTime(visitor.exitTime!), icon: Icons.logout_outlined),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (visitor.status == 'PENDING') ...[
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => context.read<VisitorBloc>().add(VisitorApproved(visitor.id)),
                            icon: const Icon(Icons.check_rounded),
                            label: const Text('Approve'),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.success,
                              minimumSize: const Size(0, 48),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => context.read<VisitorBloc>().add(VisitorRejected(visitor.id)),
                            icon: const Icon(Icons.close_rounded),
                            label: const Text('Reject'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: const BorderSide(color: AppColors.error),
                              minimumSize: const Size(0, 48),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _formatTime(DateTime dt) => '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.visitor});
  final dynamic visitor;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (visitor.status as String) {
      'APPROVED' => AppColors.success,
      'REJECTED' => AppColors.error,
      'PENDING' => AppColors.warning,
      'COMPLETED' => AppColors.primary,
      _ => AppColors.grey500,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.primaryLight.withValues(alpha: 0.1),
              child: Text(
                (visitor.visitorName as String)[0].toUpperCase(),
                style: AppTypography.displaySmall.copyWith(color: AppColors.primary),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(visitor.visitorName as String, style: AppTypography.headingMedium),
            const SizedBox(height: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.xl),
              ),
              child: Text(
                visitor.status as String,
                style: AppTypography.labelMedium.copyWith(color: statusColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(children: children),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.grey500),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.caption.copyWith(color: AppColors.grey500)),
              Text(value, style: AppTypography.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }
}
