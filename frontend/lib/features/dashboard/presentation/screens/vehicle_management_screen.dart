import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/vehicle/presentation/bloc/vehicle_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class VehicleManagementScreen extends StatefulWidget {
  const VehicleManagementScreen({super.key});

  @override
  State<VehicleManagementScreen> createState() => _VehicleManagementScreenState();
}

class _VehicleManagementScreenState extends State<VehicleManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VehicleCubit>().loadVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle Management')),
      body: BlocBuilder<VehicleCubit, VehicleState>(
        builder: (context, state) {
          if (state is VehicleLoading) {
            return const AppShimmerList();
          }
          if (state is VehicleError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<VehicleCubit>().loadVehicles(),
            );
          }
          if (state is VehiclesLoaded) {
            final vehicles = state.vehicles;
            if (vehicles.isEmpty) {
              return RefreshIndicator(
                onRefresh: () => context.read<VehicleCubit>().loadVehicles(),
                child: ListView(
                  children: const [
                    SizedBox(height: 200),
                    AppEmptyWidget(
                      message: 'No vehicles registered.',
                      icon: Icons.directions_car_outlined,
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () => context.read<VehicleCubit>().loadVehicles(),
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: vehicles.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final v = vehicles[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.directions_car_rounded, color: AppColors.primary),
                      title: Text(v.plateNumber, style: AppTypography.bodyMedium),
                      subtitle: Text(
                        [v.make, v.model, v.type].where((s) => s != null && s.isNotEmpty).join(' • '),
                        style: AppTypography.caption,
                      ),
                      trailing: v.colour != null
                          ? Text(v.colour!, style: AppTypography.caption)
                          : null,
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
