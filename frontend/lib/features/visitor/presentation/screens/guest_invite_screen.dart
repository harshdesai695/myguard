import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class GuestInviteScreen extends StatefulWidget {
  const GuestInviteScreen({super.key});
  @override
  State<GuestInviteScreen> createState() => _GuestInviteScreenState();
}

class _GuestInviteScreenState extends State<GuestInviteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _phoneC = TextEditingController();
  final _purposeC = TextEditingController();

  @override
  void dispose() { _nameC.dispose(); _phoneC.dispose(); _purposeC.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guest Invite')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Generate a shareable invite with QR code', style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600)),
                const SizedBox(height: AppSpacing.xl),
                AppTextField(label: 'Guest Name', controller: _nameC, hint: 'Enter guest name', prefixIcon: const Icon(Icons.person_outlined, size: 20), validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
                const SizedBox(height: AppSpacing.md),
                AppTextField(label: 'Phone Number', controller: _phoneC, hint: 'Enter phone number', keyboardType: TextInputType.phone, prefixIcon: const Icon(Icons.phone_outlined, size: 20), validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
                const SizedBox(height: AppSpacing.md),
                AppTextField(label: 'Purpose', controller: _purposeC, hint: 'e.g., Party, Dinner', prefixIcon: const Icon(Icons.description_outlined, size: 20)),
                const SizedBox(height: AppSpacing.xl),
                AppButton(label: 'Generate Invite', onPressed: () { if (_formKey.currentState?.validate() ?? false) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invite generated'))); context.pop(); } }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
