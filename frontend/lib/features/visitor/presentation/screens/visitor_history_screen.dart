import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/visitor/presentation/bloc/visitor_bloc.dart';
import 'package:myguard_frontend/features/visitor/presentation/bloc/visitor_bloc_models.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class VisitorHistoryScreen extends StatefulWidget {
  const VisitorHistoryScreen({super.key});

  @override
  State<VisitorHistoryScreen> createState() => _VisitorHistoryScreenState();
}

class _VisitorHistoryScreenState extends State<VisitorHistoryScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<VisitorBloc>().add(const VisitorsFetched());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<VisitorBloc>().state;
      if (state is VisitorsLoaded && state.hasMore) {
        context.read<VisitorBloc>().add(
              VisitorsFetched(page: state.currentPage + 1),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visitor History')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/resident/visitor/pre-approve'),
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Pre-Approve'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: BlocBuilder<VisitorBloc, VisitorState>(
        builder: (context, state) {
          if (state is VisitorLoading) {
            return const AppShimmerList();
          }
          if (state is VisitorError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<VisitorBloc>().add(const VisitorsFetched()),
            );
          }
          if (state is VisitorsLoaded) {
            if (state.visitors.isEmpty) {
              return const AppEmptyWidget(
                message: 'No visitors yet',
                icon: Icons.people_outline_rounded,
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<VisitorBloc>().add(const VisitorsFetched());
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: state.visitors.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.visitors.length) {
                    return const Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: AppLoader(size: 24),
                    );
                  }
                  final visitor = state.visitors[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(AppSpacing.md),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryLight.withValues(alpha: 0.1),
                        child: Text(
                          visitor.visitorName[0].toUpperCase(),
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      title: Text(visitor.visitorName, style: AppTypography.titleMedium),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppSpacing.xxs),
                          Text(visitor.purpose, style: AppTypography.bodySmall),
                          const SizedBox(height: AppSpacing.xs),
                          _StatusChip(status: visitor.status),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.push('/resident/visitor/${visitor.id}'),
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

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final (color, bgColor) = switch (status) {
      'APPROVED' => (AppColors.success, AppColors.successLight),
      'REJECTED' => (AppColors.error, AppColors.errorLight),
      'PENDING' => (AppColors.warning, AppColors.warningLight),
      'COMPLETED' => (AppColors.primary, AppColors.infoLight),
      _ => (AppColors.grey600, AppColors.grey100),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      child: Text(
        status,
        style: AppTypography.labelSmall.copyWith(color: color),
      ),
    );
  }
}
