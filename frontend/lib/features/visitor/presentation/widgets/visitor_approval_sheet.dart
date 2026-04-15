import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/visitor/domain/entities/visitor_entity.dart';
import 'package:myguard_frontend/features/visitor/presentation/bloc/visitor_bloc.dart';
import 'package:myguard_frontend/features/visitor/presentation/bloc/visitor_bloc_models.dart';

class VisitorApprovalSheet extends StatelessWidget {
  const VisitorApprovalSheet({required this.visitor, super.key});
  final VisitorEntity visitor;

  static Future<void> show(BuildContext context, VisitorEntity visitor) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => BlocProvider.value(value: context.read<VisitorBloc>(), child: VisitorApprovalSheet(visitor: visitor)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VisitorBloc, VisitorState>(
      listener: (context, state) {
        if (state is VisitorActionSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.grey300, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text('Visitor at Gate', style: AppTypography.headingSmall),
              const SizedBox(height: AppSpacing.lg),
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primaryLight.withValues(alpha: 0.1),
                child: visitor.photoUrl != null
                    ? ClipOval(child: Image.network(visitor.photoUrl!, width: 80, height: 80, fit: BoxFit.cover))
                    : const Icon(Icons.person_rounded, size: 40, color: AppColors.primary),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(visitor.visitorName, style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(visitor.visitorPhone, style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600)),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.grey100, borderRadius: BorderRadius.circular(20)),
                child: Text(visitor.purpose, style: AppTypography.bodySmall.copyWith(color: AppColors.grey700)),
              ),
              if (visitor.vehicleNumber != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.directions_car_outlined, size: 16, color: AppColors.grey500),
                    const SizedBox(width: 4),
                    Text(visitor.vehicleNumber!, style: AppTypography.bodySmall.copyWith(color: AppColors.grey600)),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => context.read<VisitorBloc>().add(VisitorApproved(visitor.id)),
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('Approve'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.success,
                        minimumSize: const Size(0, 52),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.read<VisitorBloc>().add(VisitorRejected(visitor.id)),
                      icon: const Icon(Icons.close_rounded),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        minimumSize: const Size(0, 52),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
