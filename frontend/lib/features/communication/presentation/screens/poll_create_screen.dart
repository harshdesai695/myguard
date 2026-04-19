import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_state.dart';
import 'package:myguard_frontend/features/communication/domain/repositories/communication_repository.dart';
import 'package:myguard_frontend/features/communication/presentation/bloc/poll_bloc.dart';
import 'package:myguard_frontend/injection.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
import 'package:myguard_frontend/shared/widgets/app_snackbar.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class PollCreateScreen extends StatefulWidget {
  const PollCreateScreen({super.key});
  @override
  State<PollCreateScreen> createState() => _PollCreateScreenState();
}

class _PollCreateScreenState extends State<PollCreateScreen> {
  final _questionC = TextEditingController();
  final _options = [TextEditingController(), TextEditingController()];
  bool _isSecret = false;

  @override
  void dispose() { _questionC.dispose(); for (final c in _options) { c.dispose(); } super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PollBloc, PollState>(
      listener: (context, state) {
        if (state is PollVoteSuccess) {
          AppSnackbar.success(context, message: 'Poll created');
          context.pop();
        } else if (state is PollError) {
          AppSnackbar.error(context, message: state.message);
        }
      },
      child: Scaffold(
      appBar: AppBar(title: const Text('Create Poll')),
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(AppSpacing.lg), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AppTextField(label: 'Question', controller: _questionC, hint: 'What do you want to ask?', maxLines: 2),
        const SizedBox(height: AppSpacing.lg),
        Row(children: [Text('Options', style: AppTypography.titleMedium), const Spacer(), TextButton.icon(onPressed: () => setState(() => _options.add(TextEditingController())), icon: const Icon(Icons.add, size: 18), label: const Text('Add'))]),
        const SizedBox(height: AppSpacing.sm),
        ...List.generate(_options.length, (i) => Padding(padding: const EdgeInsets.only(bottom: AppSpacing.sm), child: Row(children: [
          Expanded(child: AppTextField(label: 'Option ${i + 1}', controller: _options[i], hint: 'Enter option')),
          if (_options.length > 2) IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () => setState(() { _options[i].dispose(); _options.removeAt(i); })),
        ]))),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile(title: const Text('Secret Poll'), subtitle: Text('Hide individual votes', style: AppTypography.caption.copyWith(color: AppColors.grey500)), value: _isSecret, onChanged: (v) => setState(() => _isSecret = v)),
        const SizedBox(height: AppSpacing.xl),
        AppButton(label: 'Create Poll', onPressed: () async {
          final question = _questionC.text.trim();
          if (question.isEmpty) { AppSnackbar.error(context, message: 'Please enter a question'); return; }
          final options = _options.map((c) => c.text.trim()).where((t) => t.isNotEmpty).toList();
          if (options.length < 2) { AppSnackbar.error(context, message: 'At least 2 options required'); return; }
          final authState = context.read<AuthBloc>().state;
          final societyId = (authState is AuthAuthenticated) ? authState.user.societyId ?? '' : '';
          final now = DateTime.now();
          final repo = sl<CommunicationRepository>();
          final result = await repo.createPoll({
            'question': question,
            'options': options,
            'isSecret': _isSecret,
            'societyId': societyId,
            'startDate': now.toIso8601String(),
            'endDate': now.add(const Duration(days: 7)).toIso8601String(),
          });
          if (!context.mounted) return;
          result.fold(
            (f) => AppSnackbar.error(context, message: f.message),
            (_) { AppSnackbar.success(context, message: 'Poll created'); context.pop(); },
          );
        }),
      ]))),
    ),
    );
  }
}
