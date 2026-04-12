import 'package:flutter/material.dart' hide MaterialState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/material/presentation/bloc/material_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class MaterialGatepassScreen extends StatefulWidget {
  const MaterialGatepassScreen({super.key});

  @override
  State<MaterialGatepassScreen> createState() => _MaterialGatepassScreenState();
}

class _MaterialGatepassScreenState extends State<MaterialGatepassScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MaterialCubit>().loadGatepasses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Material Gatepass')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Gatepass'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: BlocBuilder<MaterialCubit, MaterialState>(
        builder: (context, state) {
          if (state is MaterialLoading) return const AppShimmerList();
          if (state is MaterialError) return AppErrorWidget(message: state.message, onRetry: () => context.read<MaterialCubit>().loadGatepasses());
          if (state is GatepassesLoaded) {
            if (state.gatepasses.isEmpty) return const AppEmptyWidget(message: 'No gatepasses', icon: Icons.receipt_long_outlined);
            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: state.gatepasses.length,
              itemBuilder: (context, index) {
                final gp = state.gatepasses[index];
                final typeColor = gp.type == 'INWARD' ? AppColors.success : AppColors.warning;
                final statusColor = switch (gp.status) { 'APPROVED' => AppColors.success, 'VERIFIED' => AppColors.primary, 'REJECTED' => AppColors.error, _ => AppColors.warning };
                return Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: typeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(gp.type == 'INWARD' ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded, size: 12, color: typeColor),
                              const SizedBox(width: 4),
                              Text(gp.type, style: AppTypography.labelSmall.copyWith(color: typeColor)),
                            ]),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                            child: Text(gp.status, style: AppTypography.labelSmall.copyWith(color: statusColor)),
                          ),
                        ]),
                        const SizedBox(height: AppSpacing.sm),
                        Text(gp.description, style: AppTypography.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                        if (gp.vehicleNumber != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Row(children: [
                            const Icon(Icons.directions_car_outlined, size: 14, color: AppColors.grey500),
                            const SizedBox(width: 4),
                            Text(gp.vehicleNumber!, style: AppTypography.caption.copyWith(color: AppColors.grey600)),
                          ]),
                        ],
                      ],
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
