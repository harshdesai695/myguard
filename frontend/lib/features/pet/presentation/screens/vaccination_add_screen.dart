import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/pet/presentation/bloc/pet_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class VaccinationAddScreen extends StatefulWidget {
  const VaccinationAddScreen({required this.petId, super.key});
  final String petId;

  @override
  State<VaccinationAddScreen> createState() => _VaccinationAddScreenState();
}

class _VaccinationAddScreenState extends State<VaccinationAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vaccineNameController = TextEditingController();
  final _vetNameController = TextEditingController();
  DateTime? _vaccinationDate;
  DateTime? _nextDueDate;

  @override
  void dispose() {
    _vaccineNameController.dispose();
    _vetNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Vaccination')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _vaccineNameController,
                label: 'Vaccine Name',
                hint: 'e.g. Rabies, Distemper',
                prefixIcon: const Icon(Icons.vaccines_outlined, size: 20),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              _DatePickerField(
                label: 'Vaccination Date',
                selectedDate: _vaccinationDate,
                onDateSelected: (d) => setState(() => _vaccinationDate = d),
              ),
              const SizedBox(height: AppSpacing.md),
              _DatePickerField(
                label: 'Next Due Date',
                selectedDate: _nextDueDate,
                onDateSelected: (d) => setState(() => _nextDueDate = d),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _vetNameController,
                label: 'Veterinarian Name',
                hint: 'Enter vet name',
                prefixIcon: const Icon(Icons.medical_services_outlined, size: 20),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                onPressed: _submit,
                label: 'Add Vaccination Record',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_vaccinationDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select vaccination date')));
      return;
    }
    // Submit via cubit - to be wired when use case is ready
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vaccination record added')));
    Navigator.of(context).pop();
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({required this.label, required this.selectedDate, required this.onDateSelected});
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) onDateSelected(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today_outlined),
          border: const OutlineInputBorder(),
        ),
        child: Text(
          selectedDate != null ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}' : 'Select date',
          style: selectedDate != null ? AppTypography.bodyMedium : AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
        ),
      ),
    );
  }
}
