import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class MaterialGatepassCreateScreen extends StatefulWidget {
  const MaterialGatepassCreateScreen({super.key});
  @override
  State<MaterialGatepassCreateScreen> createState() => _MaterialGatepassCreateScreenState();
}

class _MaterialGatepassCreateScreenState extends State<MaterialGatepassCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descC = TextEditingController();
  final _itemsC = TextEditingController();
  final _vehicleC = TextEditingController();
  String _type = 'OUTWARD';

  @override
  void dispose() { _descC.dispose(); _itemsC.dispose(); _vehicleC.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Gatepass')),
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(AppSpacing.lg), child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Type', style: AppTypography.labelMedium.copyWith(color: AppColors.grey700)),
        const SizedBox(height: AppSpacing.xs),
        SegmentedButton<String>(segments: const [ButtonSegment(value: 'INWARD', label: Text('Inward'), icon: Icon(Icons.arrow_downward)), ButtonSegment(value: 'OUTWARD', label: Text('Outward'), icon: Icon(Icons.arrow_upward))], selected: {_type}, onSelectionChanged: (v) => setState(() => _type = v.first)),
        const SizedBox(height: AppSpacing.md),
        AppTextField(label: 'Description', controller: _descC, hint: 'Describe materials', maxLines: 3, validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: AppSpacing.md),
        AppTextField(label: 'Items', controller: _itemsC, hint: 'List items (comma separated)'),
        const SizedBox(height: AppSpacing.md),
        AppTextField(label: 'Vehicle Number (Optional)', controller: _vehicleC, hint: 'e.g., MH12AB1234'),
        const SizedBox(height: AppSpacing.xl),
        AppButton(label: 'Submit Gatepass', onPressed: () { if (_formKey.currentState?.validate() ?? false) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gatepass submitted'))); context.pop(); } }),
      ])))),
    );
  }
}
