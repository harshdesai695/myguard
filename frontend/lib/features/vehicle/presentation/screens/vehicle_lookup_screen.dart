import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/vehicle/presentation/bloc/vehicle_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class VehicleLookupScreen extends StatefulWidget {
  const VehicleLookupScreen({super.key});

  @override
  State<VehicleLookupScreen> createState() => _VehicleLookupScreenState();
}

class _VehicleLookupScreenState extends State<VehicleLookupScreen> {
  final _plateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _searched = false;

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle Lookup')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _plateController,
                      label: 'Plate Number',
                      hint: 'Enter vehicle plate number',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  SizedBox(
                    height: 48,
                    child: AppButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _searched = true);
                          context.read<VehicleCubit>().lookupByPlate(_plateController.text.trim());
                        }
                      },
                      label: 'Search',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (_searched)
              Expanded(
                child: BlocBuilder<VehicleCubit, VehicleState>(
                  builder: (context, state) {
                    if (state is VehicleLoading) return const AppLoader();
                    if (state is VehicleError) return AppErrorWidget(message: state.message);
                    if (state is VehiclesLoaded && state.vehicles.isNotEmpty) {
                      final v = state.vehicles.first;
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundColor: AppColors.primaryLight.withValues(alpha: 0.1),
                                child: Icon(v.type == 'BIKE' ? Icons.two_wheeler_rounded : Icons.directions_car_rounded, size: 32, color: AppColors.primary),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(v.plateNumber, style: AppTypography.headingSmall),
                              const SizedBox(height: AppSpacing.xs),
                              Text('${v.make ?? ''} ${v.model ?? ''}'.trim(), style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600)),
                              const SizedBox(height: AppSpacing.md),
                              _DetailRow(label: 'Type', value: v.type),
                              _DetailRow(label: 'Colour', value: v.colour ?? 'N/A'),
                              _DetailRow(label: 'Owner', value: v.ownerUid ?? 'N/A'),
                              _DetailRow(label: 'Flat', value: v.flatId ?? 'N/A'),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.grey600)),
          Text(value, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}
