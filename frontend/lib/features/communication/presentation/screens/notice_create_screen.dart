import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
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
    return Scaffold(
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
        OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.attach_file_rounded), label: const Text('Attach Files'), style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48))),
        const SizedBox(height: AppSpacing.xl),
        AppButton(label: 'Publish Notice', onPressed: () { if (_formKey.currentState?.validate() ?? false) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notice published'))); context.pop(); } }),
      ])))),
    );
  }
}
