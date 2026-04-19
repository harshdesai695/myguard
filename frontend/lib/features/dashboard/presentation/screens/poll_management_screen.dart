import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/communication/presentation/bloc/poll_bloc.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class PollManagementScreen extends StatefulWidget {
  const PollManagementScreen({super.key});

  @override
  State<PollManagementScreen> createState() => _PollManagementScreenState();
}

class _PollManagementScreenState extends State<PollManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PollBloc>().add(const PollsFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Poll Management')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/admin/polls/create'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create Poll'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: BlocBuilder<PollBloc, PollState>(
        builder: (context, state) {
          if (state is PollLoading) return const AppShimmerList();
          if (state is PollError) {
            return AppErrorWidget(message: state.message, onRetry: () => context.read<PollBloc>().add(const PollsFetched()));
          }
          if (state is PollsLoaded) {
            if (state.polls.isEmpty) {
              return const AppEmptyWidget(message: 'No polls yet.\nTap + to create one.', icon: Icons.poll_outlined);
            }
            return RefreshIndicator(
              onRefresh: () async => context.read<PollBloc>().add(const PollsFetched()),
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: state.polls.length,
                itemBuilder: (context, index) {
                  final poll = state.polls[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Expanded(child: Text(poll.question, style: AppTypography.titleMedium)),
                            if (poll.isSecret) const Icon(Icons.visibility_off_outlined, size: 16, color: AppColors.grey500),
                          ]),
                          const SizedBox(height: AppSpacing.sm),
                          Wrap(
                            spacing: AppSpacing.xs,
                            runSpacing: AppSpacing.xs,
                            children: poll.options.map((o) => Chip(
                              label: Text(o, style: AppTypography.labelSmall),
                              visualDensity: VisualDensity.compact,
                            )).toList(),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(children: [
                            Icon(Icons.how_to_vote_outlined, size: 14, color: AppColors.grey500),
                            const SizedBox(width: 4),
                            Text('${poll.totalVotes ?? 0} votes', style: AppTypography.caption.copyWith(color: AppColors.grey500)),
                            const Spacer(),
                            if (poll.endDate != null) Text('Ends: ${poll.endDate!.day}/${poll.endDate!.month}/${poll.endDate!.year}', style: AppTypography.caption.copyWith(color: AppColors.grey500)),
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
