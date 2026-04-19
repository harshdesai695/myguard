import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/helpdesk/presentation/bloc/helpdesk_bloc.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class HelpdeskReportsScreen extends StatefulWidget {
  const HelpdeskReportsScreen({super.key});

  @override
  State<HelpdeskReportsScreen> createState() => _HelpdeskReportsScreenState();
}

class _HelpdeskReportsScreenState extends State<HelpdeskReportsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HelpdeskBloc>().add(const TicketsFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Helpdesk Reports')),
      body: BlocBuilder<HelpdeskBloc, HelpdeskState>(
        builder: (context, state) {
          if (state is HelpdeskLoading) {
            return const AppShimmerList(itemCount: 4, itemHeight: 100);
          }
          if (state is HelpdeskError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () =>
                  context.read<HelpdeskBloc>().add(const TicketsFetched()),
            );
          }
          if (state is TicketsLoaded) {
            final tickets = state.tickets;
            final total = tickets.length;
            final open = tickets.where((t) => t.status.toUpperCase() == 'OPEN').length;
            final resolved = tickets.where((t) => t.status.toUpperCase() == 'RESOLVED').length;
            final rated = tickets.where((t) => t.rating != null);
            final avgRating = rated.isNotEmpty
                ? rated.map((t) => t.rating!).reduce((a, b) => a + b) / rated.length
                : 0.0;

            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<HelpdeskBloc>().add(const TicketsFetched()),
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
                        _StatCard(
                            label: 'Total Tickets',
                            value: '$total',
                            color: AppColors.primary),
                        _StatCard(
                            label: 'Open',
                            value: '$open',
                            color: AppColors.warning),
                        _StatCard(
                            label: 'Resolved',
                            value: '$resolved',
                            color: AppColors.success),
                        _StatCard(
                            label: 'Avg Rating',
                            value: avgRating.toStringAsFixed(1),
                            color: AppColors.info),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Category Breakdown', style: AppTypography.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    ..._buildCategoryBreakdown(tickets),
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

  List<Widget> _buildCategoryBreakdown(List<dynamic> tickets) {
    final categories = <String, int>{};
    for (final t in tickets) {
      final cat = (t as dynamic).category as String;
      categories[cat] = (categories[cat] ?? 0) + 1;
    }
    if (categories.isEmpty) {
      return [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Center(
              child: Text(
                'No ticket data available for breakdown.',
                style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ];
    }
    return categories.entries.map((e) {
      return Card(
        child: ListTile(
          title: Text(e.key, style: AppTypography.bodyMedium),
          trailing: Text('${e.value}',
              style: AppTypography.titleSmall.copyWith(color: AppColors.primary)),
        ),
      );
    }).toList();
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard(
      {required this.label, required this.value, required this.color});

  final String label;
  final String value;
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
            Text(value,
                style: AppTypography.headingMedium.copyWith(color: color)),
            const SizedBox(height: AppSpacing.xxs),
            Text(label,
                style:
                    AppTypography.caption.copyWith(color: AppColors.grey600)),
          ],
        ),
      ),
    );
  }
}
