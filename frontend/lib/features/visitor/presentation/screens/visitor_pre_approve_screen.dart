import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/visitor/presentation/bloc/visitor_bloc.dart';
import 'package:myguard_frontend/features/visitor/presentation/bloc/visitor_bloc_models.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
import 'package:myguard_frontend/shared/widgets/app_snackbar.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class VisitorPreApproveScreen extends StatefulWidget {
  const VisitorPreApproveScreen({super.key});

  @override
  State<VisitorPreApproveScreen> createState() => _VisitorPreApproveScreenState();
}

class _VisitorPreApproveScreenState extends State<VisitorPreApproveScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _purposeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<VisitorBloc>().add(
            VisitorPreApproved(
              visitorName: _nameController.text.trim(),
              visitorPhone: _phoneController.text.trim(),
              purpose: _purposeController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VisitorBloc, VisitorState>(
      listener: (context, state) {
        if (state is VisitorActionSuccess) {
          AppSnackbar.success(context, message: state.message);
          context.pop();
        } else if (state is VisitorError) {
          AppSnackbar.error(context, message: state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Pre-Approve Visitor')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pre-approve a visitor for quick entry',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppTextField(
                    label: 'Visitor Name',
                    controller: _nameController,
                    hint: 'Enter visitor name',
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.person_outlined, size: 20),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Phone Number',
                    controller: _phoneController,
                    hint: 'Enter phone number',
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Phone is required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Purpose of Visit',
                    controller: _purposeController,
                    hint: 'e.g., Delivery, Guest, Maintenance',
                    textInputAction: TextInputAction.done,
                    prefixIcon: const Icon(Icons.description_outlined, size: 20),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Purpose is required' : null,
                    onSubmitted: (_) => _onSubmit(),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  BlocBuilder<VisitorBloc, VisitorState>(
                    builder: (context, state) {
                      return AppButton(
                        label: 'Pre-Approve',
                        onPressed: _onSubmit,
                        isLoading: state is VisitorLoading,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
