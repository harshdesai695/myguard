import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/society/presentation/bloc/society_bloc.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class SocietyManagementScreen extends StatefulWidget {
  const SocietyManagementScreen({super.key});

  @override
  State<SocietyManagementScreen> createState() => _SocietyManagementScreenState();
}

class _SocietyManagementScreenState extends State<SocietyManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SocietyBloc>().add(const SocietiesFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Society Management')),
      body: BlocConsumer<SocietyBloc, SocietyState>(
        listener: (context, state) {
          if (state is SocietyActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            context.read<SocietyBloc>().add(const SocietiesFetched());
          }
        },
        builder: (context, state) {
          if (state is SocietyLoading) return const AppShimmerList();
          if (state is SocietyError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<SocietyBloc>().add(const SocietiesFetched()),
            );
          }
          if (state is SocietiesLoaded && state.societies.isNotEmpty) {
            final society = state.societies.first;
            return RefreshIndicator(
              onRefresh: () async => context.read<SocietyBloc>().add(const SocietiesFetched()),
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: AppColors.primaryLight.withValues(alpha: 0.1),
                                child: const Icon(Icons.apartment_rounded, color: AppColors.primary, size: 28),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(society.name, style: AppTypography.headingMedium),
                                    Text(society.address, style: AppTypography.bodySmall.copyWith(color: AppColors.grey600)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: society.status == 'ACTIVE' ? AppColors.successLight : AppColors.grey100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  society.status ?? 'ACTIVE',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: society.status == 'ACTIVE' ? AppColors.success : AppColors.grey600,
                                  ),
                                ),
                              ),
                            ],
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Details', style: AppTypography.titleMedium),
                          const SizedBox(height: AppSpacing.md),
                          _InfoRow(label: 'City', value: society.city ?? '—'),
                          _InfoRow(label: 'State', value: society.state ?? '—'),
                          _InfoRow(label: 'Pincode', value: society.pincode ?? '—'),
                          _InfoRow(label: 'Total Blocks', value: '${society.totalBlocks ?? '—'}'),
                          _InfoRow(label: 'Total Flats', value: '${society.totalFlats ?? '—'}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: 'Edit Society Details',
                    onPressed: () => _showEditDialog(context, society),
                    variant: AppButtonVariant.outline,
                    icon: Icons.edit_rounded,
                  ),
                ],
              ),
            );
          }
          if (state is SocietyDetailLoaded) {
            return const Center(child: Text('Society loaded'));
          }
          return AppErrorWidget(
            message: 'No society data.\nConnect to the backend to load.',
            onRetry: () => context.read<SocietyBloc>().add(const SocietiesFetched()),
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, dynamic society) {
    final nameC = TextEditingController(text: society.name as String);
    final addressC = TextEditingController(text: society.address as String);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.lg, top: AppSpacing.lg, bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit Society', style: AppTypography.headingSmall),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(label: 'Name', controller: nameC, hint: 'Society name'),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Address', controller: addressC, hint: 'Address'),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Save Changes',
              onPressed: () {
                context.read<SocietyBloc>().add(SocietyUpdated(
                  societyId: society.id as String,
                  data: {'name': nameC.text, 'address': addressC.text},
                ));
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600)),
          Text(value, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}
