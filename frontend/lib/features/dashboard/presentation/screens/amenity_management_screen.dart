import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/amenity/domain/entities/amenity_entity.dart';
import 'package:myguard_frontend/features/amenity/presentation/bloc/amenity_bloc.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_state.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';
import 'package:myguard_frontend/shared/widgets/app_snackbar.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class AmenityManagementScreen extends StatefulWidget {
  const AmenityManagementScreen({super.key});

  @override
  State<AmenityManagementScreen> createState() => _AmenityManagementScreenState();
}

class _AmenityManagementScreenState extends State<AmenityManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AmenityBloc>().add(const AmenitiesFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amenity Management'),
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/admin/amenities/bookings'),
            icon: const Icon(Icons.book_online_outlined, size: 18),
            label: const Text('Bookings'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAmenityForm(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Amenity'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: BlocConsumer<AmenityBloc, AmenityState>(
        listener: (context, state) {
          if (state is AmenityActionSuccess) {
            AppSnackbar.success(context, message: state.message);
            context.read<AmenityBloc>().add(const AmenitiesFetched());
          }
          if (state is AmenityError) {
            AppSnackbar.error(context, message: state.message);
          }
        },
        buildWhen: (prev, curr) => curr is AmenityLoading || curr is AmenitiesLoaded || curr is AmenityError,
        builder: (context, state) {
          if (state is AmenityLoading) return const AppShimmerList();
          if (state is AmenityError) {
            return AppErrorWidget(message: state.message, onRetry: () => context.read<AmenityBloc>().add(const AmenitiesFetched()));
          }
          if (state is AmenitiesLoaded) {
            if (state.amenities.isEmpty) {
              return const AppEmptyWidget(message: 'No amenities configured.\nTap + to add one.', icon: Icons.sports_tennis_outlined);
            }
            return RefreshIndicator(
              onRefresh: () async => context.read<AmenityBloc>().add(const AmenitiesFetched()),
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: state.amenities.length,
                itemBuilder: (context, index) {
                  final amenity = state.amenities[index];
                  final statusColor = amenity.status == 'ACTIVE' ? AppColors.success : AppColors.grey500;
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(AppSpacing.md),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryLight.withValues(alpha: 0.1),
                        child: Icon(_amenityIcon(amenity.type), color: AppColors.primary),
                      ),
                      title: Text(amenity.name, style: AppTypography.titleMedium),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(amenity.type, style: AppTypography.caption.copyWith(color: AppColors.grey600)),
                          const SizedBox(height: AppSpacing.xxs),
                          Row(children: [
                            Icon(Icons.people_outline, size: 14, color: AppColors.grey500),
                            const SizedBox(width: 4),
                            Text('Capacity: ${amenity.capacity ?? 'â€”'}', style: AppTypography.labelSmall),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                              child: Text(amenity.status ?? 'ACTIVE', style: AppTypography.labelSmall.copyWith(color: statusColor, fontSize: 9)),
                            ),
                          ]),
                        ],
                      ),
                      trailing: const Icon(Icons.edit_outlined, size: 20, color: AppColors.grey500),
                      onTap: () => _showAmenityForm(context, amenity: amenity),
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

  IconData _amenityIcon(String type) => switch (type.toLowerCase()) {
        'gym' => Icons.fitness_center_rounded,
        'pool' || 'swimming' => Icons.pool_rounded,
        'clubhouse' || 'party hall' => Icons.celebration_rounded,
        'tennis' => Icons.sports_tennis_rounded,
        _ => Icons.sports_rounded,
      };

  void _showAmenityForm(BuildContext context, {AmenityEntity? amenity}) {
    final nameC = TextEditingController(text: amenity?.name ?? '');
    final typeC = TextEditingController(text: amenity?.type ?? '');
    final capacityC = TextEditingController(text: amenity?.capacity?.toString() ?? '');
    final formKey = GlobalKey<FormState>();
    final isEdit = amenity != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.lg, top: AppSpacing.lg, bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg),
        child: Form(
          key: formKey,
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(isEdit ? 'Edit Amenity' : 'Add Amenity', style: AppTypography.headingSmall),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(label: 'Name', controller: nameC, hint: 'e.g., Swimming Pool', validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Type', controller: typeC, hint: 'e.g., GYM, POOL, CLUBHOUSE', validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Capacity', controller: capacityC, hint: 'e.g., 50', keyboardType: TextInputType.number),
            const SizedBox(height: AppSpacing.xl),
            AppButton(label: isEdit ? 'Update' : 'Create', onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final authState = context.read<AuthBloc>().state;
                final societyId = (authState is AuthAuthenticated) ? authState.user.societyId ?? '' : '';
                final data = {'name': nameC.text.trim(), 'type': typeC.text.trim().toUpperCase(), 'societyId': societyId, if (capacityC.text.trim().isNotEmpty) 'capacity': int.tryParse(capacityC.text.trim())};
                if (isEdit) {
                  context.read<AmenityBloc>().add(AmenityUpdated(id: amenity.id, data: data));
                } else {
                  context.read<AmenityBloc>().add(AmenityCreated(data));
                }
                Navigator.pop(ctx);
              }
            }),
          ]),
        ),
      ),
    );
  }
}
