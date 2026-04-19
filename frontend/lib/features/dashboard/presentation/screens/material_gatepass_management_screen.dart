import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/material/presentation/bloc/material_cubit.dart'
    as mat;
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';
import 'package:myguard_frontend/shared/widgets/app_snackbar.dart';

class MaterialGatepassManagementScreen extends StatefulWidget {
  const MaterialGatepassManagementScreen({super.key});

  @override
  State<MaterialGatepassManagementScreen> createState() =>
      _MaterialGatepassManagementScreenState();
}

class _MaterialGatepassManagementScreenState
    extends State<MaterialGatepassManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<mat.MaterialCubit>().loadAdminGatepasses();
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return AppColors.success;
      case 'VERIFIED':
        return AppColors.info;
      default:
        return AppColors.warning;
    }
  }

  Color _typeColor(String type) {
    return type.toUpperCase() == 'INWARD' ? AppColors.info : AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gatepass Management')),
      body: BlocConsumer<mat.MaterialCubit, mat.MaterialState>(
        listener: (context, state) {
          if (state is mat.MaterialActionSuccess) {
            AppSnackbar.success(context, message: state.message);
            context.read<mat.MaterialCubit>().loadAdminGatepasses();
          }
          if (state is mat.MaterialError) {
            AppSnackbar.error(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is mat.MaterialLoading) {
            return const AppShimmerList();
          }
          if (state is mat.MaterialError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<mat.MaterialCubit>().loadAdminGatepasses(),
            );
          }
          if (state is mat.GatepassesLoaded) {
            final gatepasses = state.gatepasses;
            if (gatepasses.isEmpty) {
              return RefreshIndicator(
                onRefresh: () =>
                    context.read<mat.MaterialCubit>().loadAdminGatepasses(),
                child: ListView(
                  children: const [
                    SizedBox(height: 200),
                    AppEmptyWidget(
                      message: 'No gatepasses found.',
                      icon: Icons.receipt_long_outlined,
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<mat.MaterialCubit>().loadAdminGatepasses(),
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: gatepasses.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final gp = gatepasses[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xxs,
                                ),
                                decoration: BoxDecoration(
                                  color: _typeColor(gp.type).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  gp.type,
                                  style: AppTypography.caption.copyWith(
                                    color: _typeColor(gp.type),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xxs,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      _statusColor(gp.status).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  gp.status,
                                  style: AppTypography.caption.copyWith(
                                    color: _statusColor(gp.status),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              if (gp.status.toUpperCase() == 'PENDING')
                                TextButton.icon(
                                  onPressed: () => context
                                      .read<mat.MaterialCubit>()
                                      .approveGatepass(gp.id),
                                  icon: const Icon(Icons.check_rounded,
                                      size: 18),
                                  label: const Text('Approve'),
                                ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(gp.description,
                              style: AppTypography.bodyMedium),
                          if (gp.vehicleNumber != null) ...[
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              'Vehicle: ${gp.vehicleNumber}',
                              style: AppTypography.caption,
                            ),
                          ],
                        ],
                      ),
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
