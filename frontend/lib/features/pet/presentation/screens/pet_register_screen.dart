import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class PetRegisterScreen extends StatefulWidget {
  const PetRegisterScreen({super.key});
  @override
  State<PetRegisterScreen> createState() => _PetRegisterScreenState();
}

class _PetRegisterScreenState extends State<PetRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _breedC = TextEditingController();
  final _ageC = TextEditingController();
  String _type = 'Dog';

  @override
  void dispose() { _nameC.dispose(); _breedC.dispose(); _ageC.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Pet')),
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(AppSpacing.lg), child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(child: GestureDetector(onTap: () {}, child: CircleAvatar(radius: 48, backgroundColor: AppColors.surface, child: const Icon(Icons.add_a_photo_outlined, size: 32, color: AppColors.grey500)))),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(label: 'Name', controller: _nameC, hint: 'Pet name', validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: AppSpacing.md),
        Text('Type', style: AppTypography.labelMedium.copyWith(color: AppColors.grey700)),
        const SizedBox(height: AppSpacing.xs),
        SegmentedButton<String>(segments: const [ButtonSegment(value: 'Dog', label: Text('Dog'), icon: Icon(Icons.pets)), ButtonSegment(value: 'Cat', label: Text('Cat')), ButtonSegment(value: 'Bird', label: Text('Bird')), ButtonSegment(value: 'Other', label: Text('Other'))], selected: {_type}, onSelectionChanged: (v) => setState(() => _type = v.first)),
        const SizedBox(height: AppSpacing.md),
        AppTextField(label: 'Breed', controller: _breedC, hint: 'e.g., Labrador, Persian'),
        const SizedBox(height: AppSpacing.md),
        AppTextField(label: 'Age (years)', controller: _ageC, hint: 'e.g., 2', keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.xl),
        AppButton(label: 'Register Pet', onPressed: () { if (_formKey.currentState?.validate() ?? false) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pet registered'))); context.pop(); } }),
      ])))),
    );
  }
}
