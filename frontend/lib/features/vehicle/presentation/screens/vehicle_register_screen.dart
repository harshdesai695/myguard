import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class VehicleRegisterScreen extends StatefulWidget {
  const VehicleRegisterScreen({super.key});
  @override
  State<VehicleRegisterScreen> createState() => _VehicleRegisterScreenState();
}

class _VehicleRegisterScreenState extends State<VehicleRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _plateC = TextEditingController();
  final _makeC = TextEditingController();
  final _modelC = TextEditingController();
  final _colourC = TextEditingController();
  String _type = 'CAR';

  @override
  void dispose() { _plateC.dispose(); _makeC.dispose(); _modelC.dispose(); _colourC.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Vehicle')),
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(AppSpacing.lg), child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AppTextField(label: 'Plate Number', controller: _plateC, hint: 'e.g., MH12AB1234', prefixIcon: const Icon(Icons.pin_outlined, size: 20), validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: AppSpacing.md),
        Text('Vehicle Type', style: AppTypography.labelMedium.copyWith(color: AppColors.grey700)),
        const SizedBox(height: AppSpacing.xs),
        SegmentedButton<String>(segments: const [ButtonSegment(value: 'CAR', label: Text('Car'), icon: Icon(Icons.directions_car)), ButtonSegment(value: 'BIKE', label: Text('Bike'), icon: Icon(Icons.two_wheeler)), ButtonSegment(value: 'OTHER', label: Text('Other'))], selected: {_type}, onSelectionChanged: (v) => setState(() => _type = v.first)),
        const SizedBox(height: AppSpacing.md),
        AppTextField(label: 'Make', controller: _makeC, hint: 'e.g., Maruti, Honda'),
        const SizedBox(height: AppSpacing.md),
        AppTextField(label: 'Model', controller: _modelC, hint: 'e.g., Swift, City'),
        const SizedBox(height: AppSpacing.md),
        AppTextField(label: 'Colour', controller: _colourC, hint: 'e.g., White, Black'),
        const SizedBox(height: AppSpacing.xl),
        AppButton(label: 'Register Vehicle', onPressed: () { if (_formKey.currentState?.validate() ?? false) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vehicle registered'))); context.pop(); } }),
      ])))),
    );
  }
}
