import 'package:flutter/material.dart' hide MaterialState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/material/presentation/bloc/material_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class MaterialGatepassDetailScreen extends StatelessWidget {
  const MaterialGatepassDetailScreen({required this.gatepassId, super.key});
  final String gatepassId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gatepass Details')),
      body: BlocBuilder<MaterialCubit, MaterialState>(
        builder: (context, state) {
          if (state is MaterialLoading) return const AppLoader();
          if (state is MaterialError) return AppErrorWidget(message: state.message, onRetry: () => context.read<MaterialCubit>().loadGatepasses());
          if (state is GatepassesLoaded) {
            final gp = state.gatepasses.where((g) => g.id == gatepassId).firstOrNull;
            if (gp == null) return const AppErrorWidget(message: 'Gatepass not found');
            final typeColor = gp.type == 'INWARD' ? AppColors.success : AppColors.warning;
            final statusColor = switch (gp.status) { 'APPROVED' => AppColors.success, 'VERIFIED' => AppColors.primary, 'REJECTED' => AppColors.error, _ => AppColors.warning };
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: typeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                Icon(gp.type == 'INWARD' ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded, size: 16, color: typeColor),
                                const SizedBox(width: 4),
                                Text(gp.type, style: AppTypography.labelMedium.copyWith(color: typeColor)),
                              ]),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                              child: Text(gp.status, style: AppTypography.labelMedium.copyWith(color: statusColor)),
                            ),
                          ]),
                          const SizedBox(height: AppSpacing.lg),
                          Text(gp.description, style: AppTypography.bodyLarge, textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Details', style: AppTypography.titleMedium),
                          const SizedBox(height: AppSpacing.sm),
                          if (gp.vehicleNumber != null) _Row(label: 'Vehicle', value: gp.vehicleNumber!, icon: Icons.directions_car_outlined),
                          if (gp.expectedDate != null) _Row(label: 'Expected Date', value: gp.expectedDate!, icon: Icons.calendar_today_outlined),
                          _Row(label: 'Flat', value: gp.flatId ?? 'N/A', icon: Icons.apartment_outlined),
                          if (gp.approvedBy != null) _Row(label: 'Approved By', value: gp.approvedBy!, icon: Icons.check_circle_outline),
                          if (gp.verifiedBy != null) _Row(label: 'Verified By', value: gp.verifiedBy!, icon: Icons.verified_outlined),
                        ],
                      ),
                    ),
                  ),
                  if (gp.items != null && gp.items!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Items', style: AppTypography.titleMedium),
                            const SizedBox(height: AppSpacing.sm),
                            ...gp.items!.map((item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(children: [
                                const Icon(Icons.circle, size: 6, color: AppColors.grey500),
                                const SizedBox(width: AppSpacing.sm),
                                Text(item, style: AppTypography.bodyMedium),
                              ]),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
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

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.grey500),
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.grey600)),
          const Spacer(),
          Text(value, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}
