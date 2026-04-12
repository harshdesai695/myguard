import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/vehicle/presentation/bloc/vehicle_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VehicleCubit>().loadVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Vehicles')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Vehicle'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: BlocBuilder<VehicleCubit, VehicleState>(
        builder: (context, state) {
          if (state is VehicleLoading) return const AppShimmerList();
          if (state is VehicleError) return AppErrorWidget(message: state.message, onRetry: () => context.read<VehicleCubit>().loadVehicles());
          if (state is VehiclesLoaded) {
            if (state.vehicles.isEmpty) return const AppEmptyWidget(message: 'No vehicles registered', icon: Icons.directions_car_outlined);
            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: state.vehicles.length,
              itemBuilder: (context, index) {
                final v = state.vehicles[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(AppSpacing.md),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryLight.withValues(alpha: 0.1),
                      child: Icon(v.type == 'BIKE' ? Icons.two_wheeler_rounded : Icons.directions_car_rounded, color: AppColors.primary),
                    ),
                    title: Text(v.plateNumber, style: AppTypography.titleMedium),
                    subtitle: Text('${v.make ?? ''} ${v.model ?? ''} • ${v.colour ?? ''}', style: AppTypography.bodySmall.copyWith(color: AppColors.grey600)),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.grey100, borderRadius: BorderRadius.circular(4)),
                      child: Text(v.type, style: AppTypography.labelSmall.copyWith(color: AppColors.grey700)),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
