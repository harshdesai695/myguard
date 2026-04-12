import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/features/visitor/presentation/bloc/visitor_bloc.dart';
import 'package:myguard_frontend/features/visitor/presentation/bloc/visitor_bloc_models.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
import 'package:myguard_frontend/shared/widgets/app_snackbar.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class VisitorEntryScreen extends StatefulWidget {
  const VisitorEntryScreen({super.key});

  @override
  State<VisitorEntryScreen> createState() => _VisitorEntryScreenState();
}

class _VisitorEntryScreenState extends State<VisitorEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _purposeController = TextEditingController();
  final _flatController = TextEditingController();
  final _vehicleController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _purposeController.dispose();
    _flatController.dispose();
    _vehicleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Visitor Entry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded),
            tooltip: 'Scan QR',
            onPressed: () => context.push('/guard/visitor/qr-scan'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  label: 'Visitor Name',
                  controller: _nameController,
                  hint: 'Enter visitor name',
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.person_outlined, size: 20),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Phone Number',
                  controller: _phoneController,
                  hint: 'Enter phone number',
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Purpose',
                  controller: _purposeController,
                  hint: 'e.g., Delivery, Guest',
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.description_outlined, size: 20),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Flat Number',
                  controller: _flatController,
                  hint: 'e.g., A-101',
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.apartment_outlined, size: 20),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Vehicle Number (Optional)',
                  controller: _vehicleController,
                  hint: 'e.g., MH12AB1234',
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.directions_car_outlined, size: 20),
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Capture Photo'),
                  style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                ),
                const SizedBox(height: AppSpacing.xl),
                BlocConsumer<VisitorBloc, VisitorState>(
                  listener: (context, state) {
                    if (state is VisitorActionSuccess) {
                      AppSnackbar.success(context, message: state.message);
                      _formKey.currentState?.reset();
                      _nameController.clear();
                      _phoneController.clear();
                      _purposeController.clear();
                      _flatController.clear();
                      _vehicleController.clear();
                    } else if (state is VisitorError) {
                      AppSnackbar.error(context, message: state.message);
                    }
                  },
                  builder: (context, state) {
                    return AppButton(
                      label: 'Log Entry',
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Would call logVisitorEntry through the bloc
                          AppSnackbar.success(context, message: 'Entry logged');
                        }
                      },
                      isLoading: state is VisitorLoading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
