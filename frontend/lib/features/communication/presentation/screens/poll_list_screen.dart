import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/communication/presentation/bloc/poll_bloc.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class PollListScreen extends StatefulWidget {
  const PollListScreen({super.key});

  @override
  State<PollListScreen> createState() => _PollListScreenState();
}

class _PollListScreenState extends State<PollListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PollBloc>().add(const PollsFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Polls')),
      body: BlocBuilder<PollBloc, PollState>(
        builder: (context, state) {
          if (state is PollLoading) return const AppShimmerList();
          if (state is PollError) return AppErrorWidget(message: state.message, onRetry: () => context.read<PollBloc>().add(const PollsFetched()));
          if (state is PollsLoaded) {
            if (state.polls.isEmpty) return const AppEmptyWidget(message: 'No polls yet', icon: Icons.poll_outlined);
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
                          Text(poll.question, style: AppTypography.titleMedium),
                          const SizedBox(height: AppSpacing.sm),
                          ...poll.options.map((option) => Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                                child: OutlinedButton(
                                  onPressed: () => context.read<PollBloc>().add(PollVoted(pollId: poll.id, option: option)),
                                  style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 44), alignment: Alignment.centerLeft),
                                  child: Text(option),
                                ),
                              )),
                          const SizedBox(height: AppSpacing.xs),
                          Row(children: [
                            Icon(Icons.how_to_vote_outlined, size: 14, color: AppColors.grey500),
                            const SizedBox(width: 4),
                            Text('${poll.totalVotes ?? 0} votes', style: AppTypography.caption.copyWith(color: AppColors.grey500)),
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
