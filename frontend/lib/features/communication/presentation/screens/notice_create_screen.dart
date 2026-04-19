import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_state.dart';
import 'package:myguard_frontend/features/communication/presentation/bloc/notice_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
import 'package:myguard_frontend/shared/widgets/app_snackbar.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class NoticeCreateScreen extends StatefulWidget {
  const NoticeCreateScreen({super.key});
  @override
  State<NoticeCreateScreen> createState() => _NoticeCreateScreenState();
}

class _NoticeCreateScreenState extends State<NoticeCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleC = TextEditingController();
  final _bodyC = TextEditingController();
  String _type = 'GENERAL';

  @override
  void dispose() { _titleC.dispose(); _bodyC.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoticeCubit, NoticeState>(
      listener: (context, state) {
        if (state is NoticeActionSuccess) {
          AppSnackbar.success(context, message: state.message);
          context.pop();
        } else if (state is NoticeError) {
          AppSnackbar.error(context, message: state.message);
        }
      },
      child: Scaffold(
      appBar: AppBar(title: const Text('Create Notice')),
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(AppSpacing.lg), child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AppTextField(label: 'Title', controller: _titleC, hint: 'Notice title', validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: AppSpacing.md),
        Text('Type', style: AppTypography.labelMedium.copyWith(color: AppColors.grey700)),
        const SizedBox(height: AppSpacing.xs),
        SegmentedButton<String>(segments: const [ButtonSegment(value: 'GENERAL', label: Text('General')), ButtonSegment(value: 'URGENT', label: Text('Urgent')), ButtonSegment(value: 'MAINTENANCE', label: Text('Maintenance'))], selected: {_type}, onSelectionChanged: (v) => setState(() => _type = v.first)),
        const SizedBox(height: AppSpacing.md),
        AppTextField(label: 'Body', controller: _bodyC, hint: 'Notice content', maxLines: 6, validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(onPressed: () async { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('File picker - attach files'))); }, icon: const Icon(Icons.attach_file_rounded), label: const Text('Attach Files'), style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48))),
        const SizedBox(height: AppSpacing.xl),
        AppButton(label: 'Publish Notice', onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            final authState = context.read<AuthBloc>().state;
            final societyId = (authState is AuthAuthenticated) ? authState.user.societyId ?? '' : '';
            context.read<NoticeCubit>().createNotice({
              'title': _titleC.text.trim(),
              'body': _bodyC.text.trim(),
              'type': _type,
              'societyId': societyId,
            });
          }
        }),
      ])))),
    ),
    );
  }
}
