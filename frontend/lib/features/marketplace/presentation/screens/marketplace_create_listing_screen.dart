import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class MarketplaceCreateListingScreen extends StatefulWidget {
  const MarketplaceCreateListingScreen({super.key});
  @override
  State<MarketplaceCreateListingScreen> createState() => _MarketplaceCreateListingScreenState();
}

class _MarketplaceCreateListingScreenState extends State<MarketplaceCreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleC = TextEditingController();
  final _descC = TextEditingController();
  final _priceC = TextEditingController();
  String _category = 'Electronics';
  String _condition = 'GOOD';

  @override
  void dispose() { _titleC.dispose(); _descC.dispose(); _priceC.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Listing')),
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(AppSpacing.lg), child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        OutlinedButton.icon(onPressed: () async { final picker = await ImagePicker().pickMultiImage(); if (picker.isNotEmpty) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${picker.length} photo(s) selected'))); } }, icon: const Icon(Icons.add_photo_alternate_outlined), label: const Text('Add Photos'), style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 100))),
        const SizedBox(height: AppSpacing.md),
        AppTextField(label: 'Title', controller: _titleC, hint: 'What are you selling?', validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: AppSpacing.md),
        AppTextField(label: 'Price (₹)', controller: _priceC, hint: 'e.g., 500', keyboardType: TextInputType.number, validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: AppSpacing.md),
        Text('Category', style: AppTypography.labelMedium.copyWith(color: AppColors.grey700)),
        const SizedBox(height: AppSpacing.xs),
        DropdownButtonFormField<String>(value: _category, items: ['Electronics', 'Furniture', 'Clothing', 'Books', 'Sports', 'Kitchen', 'Other'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), onChanged: (v) => setState(() => _category = v!)),
        const SizedBox(height: AppSpacing.md),
        Text('Condition', style: AppTypography.labelMedium.copyWith(color: AppColors.grey700)),
        const SizedBox(height: AppSpacing.xs),
        SegmentedButton<String>(segments: const [ButtonSegment(value: 'NEW', label: Text('New')), ButtonSegment(value: 'LIKE_NEW', label: Text('Like New')), ButtonSegment(value: 'GOOD', label: Text('Good')), ButtonSegment(value: 'FAIR', label: Text('Fair'))], selected: {_condition}, onSelectionChanged: (v) => setState(() => _condition = v.first)),
        const SizedBox(height: AppSpacing.md),
        AppTextField(label: 'Description', controller: _descC, hint: 'Describe your item', maxLines: 4),
        const SizedBox(height: AppSpacing.xl),
        AppButton(label: 'Post Listing', onPressed: () { if (_formKey.currentState?.validate() ?? false) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Listing posted'))); context.pop(); } }),
      ])))),
    );
  }
}
