import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class DailyHelpRegisterScreen extends StatefulWidget {
  const DailyHelpRegisterScreen({super.key});
  @override
  State<DailyHelpRegisterScreen> createState() => _DailyHelpRegisterScreenState();
}

class _DailyHelpRegisterScreenState extends State<DailyHelpRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _phoneC = TextEditingController();
  String _selectedType = 'Maid';

  @override
  void dispose() { _nameC.dispose(); _phoneC.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Daily Help')),
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(AppSpacing.lg), child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AppTextField(label: 'Name', controller: _nameC, hint: 'Enter name', prefixIcon: const Icon(Icons.person_outlined, size: 20), validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: AppSpacing.md),
        AppTextField(label: 'Phone', controller: _phoneC, hint: 'Enter phone', keyboardType: TextInputType.phone, prefixIcon: const Icon(Icons.phone_outlined, size: 20), validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: AppSpacing.md),
        Text('Type', style: AppTypography.labelMedium.copyWith(color: AppColors.grey700)),
        const SizedBox(height: AppSpacing.xs),
        SegmentedButton<String>(
          segments: const [ButtonSegment(value: 'Maid', label: Text('Maid')), ButtonSegment(value: 'Cook', label: Text('Cook')), ButtonSegment(value: 'Driver', label: Text('Driver')), ButtonSegment(value: 'Nanny', label: Text('Nanny'))],
          selected: {_selectedType},
          onSelectionChanged: (v) => setState(() => _selectedType = v.first),
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(onPressed: () async { final picker = await ImagePicker().pickImage(source: ImageSource.camera); if (picker != null) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo captured'))); } }, icon: const Icon(Icons.camera_alt_outlined), label: const Text('Upload Photo'), style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48))),
        const SizedBox(height: AppSpacing.xl),
        AppButton(label: 'Register', onPressed: () { if (_formKey.currentState?.validate() ?? false) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Daily help registered'))); context.pop(); } }),
      ])))),
    );
  }
}
