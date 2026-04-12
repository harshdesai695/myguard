import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class EIntercomScreen extends StatefulWidget {
  const EIntercomScreen({super.key});

  @override
  State<EIntercomScreen> createState() => _EIntercomScreenState();
}

class _EIntercomScreenState extends State<EIntercomScreen> {
  final _flatController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _flatController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('E-Intercom')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send a message to a flat resident',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              label: 'Flat Number',
              controller: _flatController,
              hint: 'e.g., A-101',
              prefixIcon: const Icon(Icons.apartment_outlined, size: 20),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Message',
              controller: _messageController,
              hint: 'Enter your message',
              maxLines: 3,
              prefixIcon: const Icon(Icons.message_outlined, size: 20),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Send Notification',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notification sent to flat')),
                );
              },
              icon: Icons.send_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
