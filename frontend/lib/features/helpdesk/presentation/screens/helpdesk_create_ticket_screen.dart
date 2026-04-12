import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class HelpdeskCreateTicketScreen extends StatefulWidget {
  const HelpdeskCreateTicketScreen({super.key});
  @override
  State<HelpdeskCreateTicketScreen> createState() => _HelpdeskCreateTicketScreenState();
}

class _HelpdeskCreateTicketScreenState extends State<HelpdeskCreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleC = TextEditingController();
  final _descC = TextEditingController();
  String _category = 'Plumbing';
  String _priority = 'MEDIUM';

  @override
  void dispose() { _titleC.dispose(); _descC.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Ticket')),
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(AppSpacing.lg), child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AppTextField(label: 'Title', controller: _titleC, hint: 'Brief description', validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: AppSpacing.md),
        Text('Category', style: AppTypography.labelMedium.copyWith(color: AppColors.grey700)),
        const SizedBox(height: AppSpacing.xs),
        DropdownButtonFormField<String>(value: _category, items: ['Plumbing', 'Electrical', 'Civil', 'Cleaning', 'Security', 'Other'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), onChanged: (v) => setState(() => _category = v!)),
        const SizedBox(height: AppSpacing.md),
        Text('Priority', style: AppTypography.labelMedium.copyWith(color: AppColors.grey700)),
        const SizedBox(height: AppSpacing.xs),
        SegmentedButton<String>(segments: const [ButtonSegment(value: 'LOW', label: Text('Low')), ButtonSegment(value: 'MEDIUM', label: Text('Medium')), ButtonSegment(value: 'HIGH', label: Text('High')), ButtonSegment(value: 'CRITICAL', label: Text('Critical'))], selected: {_priority}, onSelectionChanged: (v) => setState(() => _priority = v.first)),
        const SizedBox(height: AppSpacing.md),
        AppTextField(label: 'Description', controller: _descC, hint: 'Describe the issue', maxLines: 4, validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.attach_file_rounded), label: const Text('Attach Files'), style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48))),
        const SizedBox(height: AppSpacing.xl),
        AppButton(label: 'Submit Ticket', onPressed: () { if (_formKey.currentState?.validate() ?? false) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ticket created'))); context.pop(); } }),
      ])))),
    );
  }
}
