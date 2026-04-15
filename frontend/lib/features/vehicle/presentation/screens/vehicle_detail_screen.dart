import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/vehicle/presentation/bloc/vehicle_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class VehicleDetailScreen extends StatefulWidget {
  const VehicleDetailScreen({required this.vehicleId, super.key});
  final String vehicleId;

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle Details')),
      body: BlocBuilder<VehicleCubit, VehicleState>(
        builder: (context, state) {
          if (state is VehicleLoading) return const AppLoader();
          if (state is VehicleError) return AppErrorWidget(message: state.message, onRetry: () => context.read<VehicleCubit>().loadVehicles());
          if (state is VehiclesLoaded) {
            final vehicle = state.vehicles.where((v) => v.id == widget.vehicleId).firstOrNull;
            if (vehicle == null) return const AppErrorWidget(message: 'Vehicle not found');
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.primaryLight.withValues(alpha: 0.1),
                            child: Icon(vehicle.type == 'BIKE' ? Icons.two_wheeler_rounded : Icons.directions_car_rounded, size: 40, color: AppColors.primary),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(vehicle.plateNumber, style: AppTypography.headingMedium),
                          const SizedBox(height: AppSpacing.xs),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.grey100, borderRadius: BorderRadius.circular(20)),
                            child: Text(vehicle.type, style: AppTypography.labelSmall.copyWith(color: AppColors.grey700)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          _InfoRow(label: 'Make', value: vehicle.make ?? 'N/A', icon: Icons.factory_outlined),
                          const Divider(height: 1),
                          _InfoRow(label: 'Model', value: vehicle.model ?? 'N/A', icon: Icons.model_training_outlined),
                          const Divider(height: 1),
                          _InfoRow(label: 'Colour', value: vehicle.colour ?? 'N/A', icon: Icons.palette_outlined),
                          if (vehicle.parkingSlotId != null) ...[
                            const Divider(height: 1),
                            _InfoRow(label: 'Parking Slot', value: vehicle.parkingSlotId!, icon: Icons.local_parking_outlined),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.grey500),
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600)),
          const Spacer(),
          Text(value, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}
